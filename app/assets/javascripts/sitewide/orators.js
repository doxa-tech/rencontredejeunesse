$(document).on("turbolinks:load", function() {

  $(".person").click(function() {
    var $parent = $(this);
    $parent.find(".text").animate({
      height: "200px"
    }, 2000);
  });
});
