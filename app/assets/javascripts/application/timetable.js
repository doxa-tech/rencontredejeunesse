$(document).on("DOMContentLoaded", function() {

  $timetableContent = $("#timetable-content");
  $timetableLinks = $("#timetable-links");

  $timetableLinks.find("h2").click(function() {
    var $link = $(this);
    var day = $link.data("day");
    $timetableLinks.find(".active").removeClass("active");
    $link.addClass("active");
    $timetableContent.find(".active").fadeOut(300, function() {
      $(this).removeClass("active");
      $timetableContent.find("." + day).fadeIn(300).addClass("active");
    });
  });
});
