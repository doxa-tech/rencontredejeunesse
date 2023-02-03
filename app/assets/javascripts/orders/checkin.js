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

  function onScanSuccess(decodedText, decodedResult) {
    $ticket_id.val(decodedText);
  }
  
  var html5QrCode = new Html5Qrcode("reader");
  var config = { fps: 10, qrbox: { width: 250, height: 250 } };
  html5QrCode.start({ facingMode: "environment" }, config, onScanSuccess);
  
});
