/* Landing scroll-spy: highlight the left-nav link whose section crosses the
   reading band. Self-contained IntersectionObserver; degrades to a no-op. */
(function () {
  'use strict';
  var links = Array.prototype.slice.call(document.querySelectorAll('.landing-nav-link'));
  if (!links.length || typeof IntersectionObserver === 'undefined') return;

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

  var current = sections[0].id;
  var observer = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) current = entry.target.id;
      });
      activate(current);
    },
    { rootMargin: '-15% 0px -70% 0px', threshold: 0 }
  );

  sections.forEach(function (section) {
    observer.observe(section);
  });
  activate(current);
})();
