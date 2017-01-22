$(document).on("turbolinks:load", function() {

  $programContent = $("#program-content");
  $programLinks = $("#program-links");

  $programLinks.find("a").click(function() {
    var $link = $(this);
    var day = $link.data("day");
    $programLinks.find(".active").removeClass("active");
    $link.addClass("active");
    $programContent.find(".active").fadeOut(300, function() {
      $(this).removeClass("active");
      $programContent.find("." + day).fadeIn(300).addClass("active");  
    });
  });
});
