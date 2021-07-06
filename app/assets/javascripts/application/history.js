$(document).on("DOMContentLoaded", function() {

  var $historyLinks = $("#history").find(".history-links");

  $historyLinks.on("click", "p", function(e) {
    var $currentLink = $historyLinks.find(".selected");
    var currentHistory = $currentLink.attr("data-content");
    var $currentHistory = $("#" + currentHistory);

    var $newLink = $(this);
    var newHistory = $newLink.attr("data-content");
    var $newHistory = $("#" + newHistory);

    $currentLink.removeClass("selected");
    $newLink.addClass("selected");
    $currentHistory.removeClass("selected");
    $newHistory.addClass("selected");

  });

});
