document.body.onclick = function(e) {
  var target = e.target;
  if(target.classList.contains("lightbox-open")) {
    var $content = document.getElementById(target.getAttribute("content"));
    fadeIn($content, function() {
      document.body.classList.add("noscroll");
      $content.classList.add("show");
    });
  }
  if(target.classList.contains("lightbox-close")) {
    document.body.classList.remove("noscroll");
    target.parentElement.parentElement.parentElement.classList.remove("show");
  }
  if(target.classList.contains("lightbox-wrap")) {
    document.body.classList.remove("noscroll");
    target.classList.remove("show");
  }
};
