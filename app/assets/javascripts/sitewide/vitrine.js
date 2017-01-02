$(document).on("ready page:load", function() {
  var soon = $("#soon");
  var behind = $("#behind");
  soon.click(function() {
    soon.addClass("open");
  });
  behind.click(function() {
    soon.removeClass("open");
  });
});
