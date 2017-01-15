$(document).on("ready page:load", function() {

  $("#burger-menu").click(function() {
    $("#content-menu").addClass("active");
  });

  $("#close-menu").click(function() {
    $("#content-menu").removeClass("active");
  })

});
