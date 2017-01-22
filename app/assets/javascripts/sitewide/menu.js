$(document).on("turbolinks:load", function() {

  $contentMenu = $("#content-menu");

  $("#burger-menu").click(function() {
    $contentMenu.addClass("active");
  });

  $contentMenu.click(function() {
    $contentMenu.removeClass("active");
  })

});
