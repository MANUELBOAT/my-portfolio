<script>
document.addEventListener("DOMContentLoaded", function() {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach(entry => {
        if(entry.isIntersecting) {
          entry.target.classList.add('fade-in');
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.13 }
  );
  document.querySelectorAll('section').forEach(section => {
    observer.observe(section);
  });
});
</script>