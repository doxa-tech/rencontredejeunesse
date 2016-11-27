$(document).on("turbolinks:load", function() {

  var $entries = $(".amount-entries"),
      $amount = $("#amount");

  $entries.change(function() {
    $amount.html(calculate_amount($entries));
  })

});

function calculate_amount($entries) {
  var entries = parseInt($entries.val()) || 0;
  return entries * 25 + 2
}
