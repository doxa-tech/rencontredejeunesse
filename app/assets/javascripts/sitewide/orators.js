$(document).on("turbolinks:load", function() {

  $(".person").click(function() {
    $(".text.active").css("height", 0).removeClass("active");
    $(this).find(".text").animate({
      height: "270px"
    }, 800, function() {
      $(this).addClass("active");
    });
  });
});
