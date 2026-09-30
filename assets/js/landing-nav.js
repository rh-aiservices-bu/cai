/* Landing scroll-spy: highlight the left-nav link for the section under the
   reading band. A scroll-position rule — the last section whose top sits above
   the band's lower edge — is deterministic regardless of scroll direction
   (an IntersectionObserver callback's entry order is not: two sections can
   share the band across their boundary, and the winner would then depend on
   which one entered last). At the bottom of the page the last section wins,
   since a short final section can never reach the band. Degrades to a no-op. */
(function () {
  'use strict';
  var links = Array.prototype.slice.call(document.querySelectorAll('.landing-nav-link'));
  if (!links.length) return;

  var byId = {};
  var sections = [];
  links.forEach(function (link) {
    var id = (link.getAttribute('href') || '').replace(/^#/, '');
    var section = id && document.getElementById(id);
    if (section) {
      byId[id] = link;
      sections.push(section);
    }
  });
  if (!sections.length) return;

  function activate(id) {
    links.forEach(function (link) {
      link.classList.toggle('landing-nav-link--active', link === byId[id]);
    });
  }

  function atBottom() {
    return window.scrollY + window.innerHeight >= document.documentElement.scrollHeight - 2;
  }

  function currentSection() {
    var line = window.scrollY + window.innerHeight * 0.3;
    var current = sections[0].id;
    for (var i = 0; i < sections.length; i++) {
      if (sections[i].getBoundingClientRect().top + window.scrollY <= line) current = sections[i].id;
    }
    return current;
  }

  var ticking = false;
  function update() {
    if (ticking) return;
    ticking = true;
    requestAnimationFrame(function () {
      ticking = false;
      if (atBottom()) activate(sections[sections.length - 1].id);
      else activate(currentSection());
    });
  }

  window.addEventListener('scroll', update, { passive: true });
  window.addEventListener('resize', update, { passive: true });
  update();
})();
