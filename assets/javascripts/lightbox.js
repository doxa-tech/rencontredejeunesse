document.body.onclick = function(e) {
  var target = e.target;
  if(target.classList.contains("lightbox-open")) {
    var $content = document.getElementById(target.getAttribute("content"));
    fadeIn($content, function() {
      document.body.classList.add("noscroll");
      $content.style.display = "flex";
    });
  }
  if(target.classList.contains("lightbox-close")) {
    document.body.classList.remove("noscroll");
    target.parentElement.parentElement.parentElement.style.display = "none";
  }
  if(target.classList.contains("lightbox-wrap")) {
    document.body.classList.remove("noscroll");
    target.style.display = "none";
  }
};
