var $body = document.body;
var $topbar = document.getElementById("topbar");
var limit = document.getElementById('home').offsetHeight - 150;

var options = {
      speed: 1000,
      offset: 70
};

gumshoe.init();
smoothScroll.init(options);

window.onload = function() {
  if (window.location.hash) {
    smoothScroll.animateScroll(null, window.location.hash, options);
  }
}

var displayHeader = function() {

  if(!$body.classList.contains("fixed") && window.pageYOffset > limit) {
    fadeIn($topbar, function() {
      removeScrollEvent();
      $body.classList.add("fixed");
    }, addScrollEvent);
  }
  if($body.classList.contains("fixed") && window.pageYOffset < limit) {
    fadeOut($topbar, removeScrollEvent, function() {
      $body.classList.remove("fixed");
      $topbar.style.opacity = 1;
      addScrollEvent();
    });
  }
};

var addScrollEvent = function() {
  window.addEventListener("scroll", displayHeader);
};
var removeScrollEvent = function() {
  window.removeEventListener("scroll", displayHeader);
};

addScrollEvent();
