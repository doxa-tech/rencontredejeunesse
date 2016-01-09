var $poster = document.getElementById("poster");

var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('home-video', {
    width: '100%',
    height: '100%',
    videoId: '_Scym_ZG2Vw',
    events: {
      'onReady': onPlayerReady
    }
  });
}

function onPlayerReady() {
  if($poster.style.visibility === "hidden") {
    player.playVideo();
  }
}

$poster.addEventListener("click", function() {
  $poster.style.visibility = "hidden";
  if(player) {
    player.playVideo();
  }
});
