$(document).on("turbolinks:load", function() {

  var closeBtn = document.getElementById("close-header");
  var headerBtn = document.getElementById("header-btn");
  var headerFrame = document.getElementById("header-frame");

  var hideHeader = function() {
    headerFrame.style.display = "none";
  }

  headerBtn.onclick = function() {
    headerFrame.style.display = "block";
  }

  closeBtn.onclick = hideHeader;

  gumshoe.init({
    callback: hideHeader
  });

});
