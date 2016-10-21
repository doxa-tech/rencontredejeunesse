$(document).on("turbolinks:load", function() {

  var $entries = $(".amount-entries"),
      $girl_beds = $(".amount-girlbeds"),
      $boy_beds = $(".amount-boybeds"),
      $amount = $("#amount");

  $entries.add($girl_beds).add($boy_beds).change(function() {
    $amount.html(calculate_amount($entries, $girl_beds, $boy_beds));
  })

});

function calculate_amount($entries, $girl_beds, $boy_beds) {
  var girl_beds = parseInt($girl_beds.val()) || 0,
      boy_beds = parseInt($boy_beds.val()) || 0,
      entries = parseInt($entries.val()) || 0;
  return entries * 50 + (boy_beds + girl_beds) * 20 + 5
}
