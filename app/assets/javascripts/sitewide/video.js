var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
tag.setAttribute("data-turbolinks-track", "reload");
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('yt-player', {
    width: '100%',
    height: '100%',
    playerVars: { 'showinfo': 1 },
    videoId: '31lNK-Ica7M',
  });
}
