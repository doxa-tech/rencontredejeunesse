var options = {
      speed: 1000,
      offset: 70
};

gumshoe.init();
smoothScroll.init(options);

if (window.location.hash) {
  smoothScroll.animateScroll(null, window.location.hash, options);
}

var $burger = document.getElementById("burger-menu"),
    $topbar = document.getElementById("topbar"),
    $video = document.getElementById("home-video-wrap"),
    $body = document.body;

$burger.onclick = function(e) {
  if(!$topbar.classList.contains("open")) {
    $topbar.classList.add("open");
    $video.style.visibility = "hidden"; // iOS 7 fix
    player.getIframe().style.display = "none";
    e.stopPropagation();
  }
};
$topbar.onclick = function(e) {
  if($topbar.classList.contains("open")) {
    $video.style.visibility = "visible"; // iOS 7 fix
    $topbar.classList.remove("open");
  }
};

var limit = document.getElementById('home').offsetHeight - 150;

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
