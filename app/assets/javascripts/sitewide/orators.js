$(document).on("turbolinks:load", function() {

  $("#program .person").click(function() {
    var $personText = $(this).find(".text");
    if($personText.hasClass("active")) {
      $personText.css("height", 0).removeClass("active");
    } else {
      $(".text.active").css("height", 0).removeClass("active");
      $personText.animate({
        height: "270px"
      }, 500, function() {
        $personText.addClass("active");
      });
    }
  });

  // FAQ
  var $faqText = $("#inscription .text");

  $("#inscription a.faq").click(function() {
    if($faqText.hasClass("active")) {
      $faqText.css("height", 0).removeClass("active");
    } else {
      $(".text.active").css("height", 0).removeClass("active");
      $faqText.animate({
        height: "600px"
      }, 500, function() {
        $faqText.addClass("active");
      });
    }
  });
});
