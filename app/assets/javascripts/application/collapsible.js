// copied from https://www.w3schools.com/howto/tryit.asp?filename=tryhow_js_collapsible_animate

$(document).on("turbolinks:load", function () {
  var coll = document.getElementsByClassName("collapsible-button");
  var i;

  for (i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function () {
      console.log("Hey");
      this.classList.toggle("collapsible-active");
      var content = this.nextElementSibling;
      if (content.style.maxHeight) {
        content.style.maxHeight = null;
      } else {
        content.style.maxHeight = content.scrollHeight + "px";
      }
    });
  }
});