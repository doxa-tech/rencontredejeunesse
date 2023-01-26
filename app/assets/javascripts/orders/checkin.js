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
  
  function onScanFailure(error) {
    // handle scan failure, usually better to ignore and keep scanning.
    console.warn(`Code scan error = ${error}`);
  }
  
  var html5QrcodeScanner = new Html5QrcodeScanner(
    "reader",
    { fps: 10, qrbox: {width: 250, height: 250} },
    /* verbose= */ false);
  html5QrcodeScanner.render(onScanSuccess, onScanFailure);

});
