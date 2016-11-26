$(document).on("ready page:load", function() {
  $('body').on("click", "#flash .close", function() {
    $('#flash').hide();
  });
});