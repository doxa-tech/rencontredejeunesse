document.body.onclick = function(e) {
  var target = e.target;
  if(target.classList.contains("lightbox-open")) {
    target.nextElementSibling.style.display = "flex";
  }
  if(target.classList.contains("lightbox-close")) {
    target.parentElement.parentElement.parentElement.style.display = "none";
  }
  if(target.classList.contains("lightbox-wrap")) {
    target.style.display = "none";
  }
};
