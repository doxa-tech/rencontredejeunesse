$video = document.getElementById("home-video");
$video.addEventListener('click', function (event) {
    event.preventDefault(); // Prevent the default behaviour in Firefox
    if (this.paused) {
    	  $video.controls = true;
        this.play();
    } else {
        this.pause();
    }
});
