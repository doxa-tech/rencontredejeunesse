$(document).on("turbolinks:load", function() {

  $("#program .person").click(function() {
    var $text = $(this).find(".text");
    if($text.hasClass("active")) {
      $text.css("height", 0).removeClass("active");
    } else {
      $(".text.active").css("height", 0).removeClass("active");
      $text.animate({
        height: "270px"
      }, 500, function() {
        $text.addClass("active");
      });
    }
  });

  // FAQ
  $("#inscription a.faq").click(function() {
    var $text = $("#inscription .text");
    if($text.hasClass("active")) {
      $text.css("height", 0).removeClass("active");
    } else {
      $(".text.active").css("height", 0).removeClass("active");
      $text.animate({
        height: "600px"
      }, 500, function() {
        $text.addClass("active");
      });
    }
  });
});
