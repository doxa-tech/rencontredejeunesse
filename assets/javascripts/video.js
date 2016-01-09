var $poster = document.getElementById("poster");

var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('home-video', {
    height: '100%',
    width: '100%',
    videoId: '_Scym_ZG2Vw',
  });
}

$poster.addEventListener("click", function() {
  $poster.style.visibility = "hidden";
  player.playVideo();
});
