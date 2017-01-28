$(document).on("turbolinks:load", function() {

  $contentMenu = $("#content-menu");

  $("#burger-menu").click(function() {
    $contentMenu.animate({
      width: "400px"
    });
  });

  $contentMenu.click(function() {
    $contentMenu.animate({
      width: "0"
    }, 200);
  })

});
