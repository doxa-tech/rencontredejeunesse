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

});
