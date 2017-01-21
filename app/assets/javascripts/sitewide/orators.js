$(document).on("turbolinks:load", function() {

  $(".person").click(function() {
    var $text = $(this).find(".text");
    if($text.hasClass("active")) {
      $text.css("height", 0).removeClass("active");
    } else {
      $(".text.active").css("height", 0).removeClass("active");
      $text.animate({
        height: "270px"
      }, 800, function() {
        $text.addClass("active");
      });
    }
  });
});
