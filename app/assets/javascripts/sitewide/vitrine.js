$(document).on("ready page:load", function() {
  var soon = $("#soon");
  var behind = $("#behind");
  var pulse = $("#pulse");

  soon.click(function() {
    soon.addClass("open");
    pulse.hide();
  });
  behind.click(function() {
    soon.removeClass("open");
    pulse.show();
  });

  // browser not supporting video looping
  var video = document.getElementsByTagName('video')[0];

  if (typeof video.loop == 'boolean') { // loop supported
    video.loop = true;
  } else { // loop property not supported
    video.on('ended', function () {
      this.currentTime = 0;
      this.play();
    }, false);
  }

});
