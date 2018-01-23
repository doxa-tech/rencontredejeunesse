$(document).on("turbolinks:load", function() {
  $("body").on("click", "#flash .close", function() {
    $("#flash").hide();
  });
});
