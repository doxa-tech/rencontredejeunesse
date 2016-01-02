gumshoe.init();
smoothScroll.init({
  offset: 71
});

if (window.location.hash) {
  smoothScroll.animateScroll(null, window.location.hash, { offset: 71 });
}

var $burger = document.getElementById("burger-menu"),
    $topbar = document.getElementById("topbar"),
    $body = document.body;

$burger.onclick = function(e) {
  if(!$topbar.classList.contains("open")) {
    $topbar.classList.add("open");
    e.stopPropagation();
  }
};
$topbar.onclick = function(e) {
  if($topbar.classList.contains("open")) {
    $topbar.classList.remove("open");
  }
};

var displayHeader = function() {
  var limit = 400;
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
