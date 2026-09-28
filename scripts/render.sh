#!/bin/sh
# scripts/render.sh — control the local Hugo render (dev server).
# Usage: scripts/render.sh start|stop|restart|status|logs [n]|follow
# Env:   RENDER_PORT (default 1313)
set -u
cd "$(dirname "$0")/.." || exit 1

port="${RENDER_PORT:-1313}"
pid_file="/tmp/cai-render-${port}.pid"
log_file="/tmp/cai-render-${port}.log"

# Local URL mirrors the deployed subpath in hugo.yaml; quotes tolerated.
base_url=$(awk '/^baseURL:/ {print $2}' hugo.yaml 2>/dev/null || true)
path=$(printf '%s' "$base_url" | sed -E "s|['\"]||g; s|https?://||; s|^[^/]+/||" 2>/dev/null || true)
url="http://localhost:${port}${path:+/$path}"

read_pid() { cat "$pid_file" 2>/dev/null || true; }

running() {
    [ -f "$pid_file" ] && kill -0 "$(read_pid)" 2>/dev/null
}

# Trust the pid file only while the process still runs hugo: a reused
# pid must never receive our signals.
is_ours() {
    case "$(ps -p "$(read_pid)" -o comm= 2>/dev/null)" in *hugo*) return 0 ;; *) return 1 ;; esac
}

http_code() {
    curl -s -o /dev/null -w '%{http_code}' "$url" 2>/dev/null
}

wait_ready() {
    i=0
    while :; do
        code=$(http_code)
        if [ "$code" != "000" ]; then
            [ "$code" = "404" ] && echo "serving, but $url 404s — check the baseURL path in hugo.yaml" >&2
            return 0
        fi
        if ! kill -0 "$(read_pid)" 2>/dev/null; then
            echo "render exited during startup — last log lines:" >&2
            tail -5 "$log_file" >&2 2>/dev/null || true
            rm -f "$pid_file"
            return 1
        fi
        i=$((i + 1))
        if [ "$i" -ge 60 ]; then
            echo "render not serving after 30s — log: $log_file" >&2
            return 1
        fi
        sleep 0.5
    done
}

start() {
    if running; then
        echo "already running: pid $(read_pid) — $url"
        return 0
    fi
    if pids=$(lsof -ti tcp:"$port" -sTCP:LISTEN 2>/dev/null); then
        echo "port ${port} is busy (pid ${pids}: $(ps -p ${pids} -o comm= 2>/dev/null | tr '\n' ' ')|) — kill ${pids}, or set RENDER_PORT" >&2
        return 1
    fi
    hugo server --port "$port" --bind 127.0.0.1 >"$log_file" 2>&1 &
    echo $! >"$pid_file"
    if wait_ready; then
        echo "render started: pid $(read_pid) — $url"
    else
        return 1
    fi
}

stop() {
    if ! running; then
        rm -f "$pid_file"
        echo "not running"
        return 0
    fi
    pid=$(read_pid)
    if is_ours; then
        kill "$pid" 2>/dev/null
        i=0
        while kill -0 "$pid" 2>/dev/null; do
            i=$((i + 1))
            if [ "$i" -ge 10 ]; then
                kill -9 "$pid" 2>/dev/null
                break
            fi
            sleep 0.5
        done
    fi
    rm -f "$pid_file"
    echo "render stopped (pid ${pid})"
}

status() {
    if running; then
        echo "running: pid $(read_pid) — $url"
    else
        echo "not running (log: $log_file)"
    fi
}

logs() {
    if [ ! -f "$log_file" ]; then
        echo "no log yet: $log_file" >&2
        exit 1
    fi
    tail -n "${1:-20}" "$log_file"
}

follow() {
    if [ ! -f "$log_file" ]; then
        echo "no log yet: $log_file" >&2
        exit 1
    fi
    tail -f "$log_file"
}

usage() {
    cat <<'EOF'
scripts/render.sh — control the local Hugo render.

usage: scripts/render.sh <command>

commands:
  start        start the render in the background and wait until it serves
  stop         stop the render (idempotent)
  restart      stop, then start
  status       show pid and URL
  logs [n]     show the last n lines (default 20)
  follow       tail the render output

env: RENDER_PORT (default 1313)
EOF
}

case "${1:-}" in
    start) start ;;
    stop) stop ;;
    restart) stop && start ;;
    status) status ;;
    logs) shift && logs "$@" ;;
    follow) follow ;;
    -h|--help|help) usage ;;
    *) usage >&2; exit 2 ;;
esac
