$(document).on("DOMContentLoaded", function() {

  $ticket_id = $("#ticket_id");
  $form = $("#checkin-form");

  $ticket_id.focus();

  $ticket_id.keyup(function() {
    if($ticket_id.val().length == 14) {
      $form.submit();
    }
  });

  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });

});
