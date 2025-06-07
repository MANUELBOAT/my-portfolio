document.addEventListener("DOMContentLoaded", function() {
  const sections = document.querySelectorAll('section');
  if (sections.length === 0) return;

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('fade-in');
          observer.unobserve(entry.target);
        }
      });
    },
    { 
      threshold: 0.05,
      rootMargin: "0px 0px -50px 0px"
    }
  );

  sections.forEach(section => observer.observe(section));
}); 