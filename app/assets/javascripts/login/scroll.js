$(document).on("turbolinks:load", function() {

  $("#arrow-down").click(function() {

    $('html, body').animate({
      scrollTop: $("#home").height()
    }, 1000);

  })

});
