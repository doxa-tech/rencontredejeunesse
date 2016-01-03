$video = document.getElementById("home-video");
$video.onclick = function() {
    if($video.paused) {
      $video.play();
      $video.controls = true;
    } else {
      $video.pause();
    }
};
