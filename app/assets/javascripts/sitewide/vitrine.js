$(document).on("ready page:load", function() {
  var soon = $("#soon");
  var behind = $("#behind");
  soon.click(function() {
    soon.addClass("open");
  });
  behind.click(function() {
    soon.removeClass("open");
  });

  // browser not supporting video looping
  var video = document.getElementById('video');
  if (typeof video.loop == 'boolean') { // loop supported
    video.loop = true;
  } else { // loop property not supported
    video.on('ended', function () {
      this.currentTime = 0;
      this.play();
    }, false);
  }

});
