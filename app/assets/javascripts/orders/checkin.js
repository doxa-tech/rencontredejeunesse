$(document).on("turbolinks:load", function() {

  $order_id = $("#order_id");
  $form = $("#checkin-form");

  $order_id.focus();

  $order_id.keydown(function() {
    if($order_id.val().length == 14) {
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
