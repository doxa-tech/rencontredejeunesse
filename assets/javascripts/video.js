var $video = document.getElementById("home-video"),
    isFirefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1;

if(isFirefox) { // Firefox
  $video.addEventListener('click', function () {
    if (!this.currentTime) {
  	  this.controls = true;
      this.play();
    }
  });
} else { // Other browsers
  $video.addEventListener('click', function () {
    if (this.paused) {
  	  this.controls = true;
      this.play();
    } else {
      this.pause();
    }
  });
}
