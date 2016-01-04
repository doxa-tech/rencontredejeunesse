window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame ||
                              window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;

function fadeOut(el, startCallback, endCallback){
  el.style.opacity = 1;
  typeof startCallback === "function" && startCallback();
  console.log("start");

  (function fade() {
    el.style.opacity = Math.round((el.style.opacity - 0.1) * 10) / 10;
    if (el.style.opacity < 0) {
      typeof endCallback === "function" && endCallback();
    } else {
      requestAnimationFrame(fade);
    }
  })();
}

function fadeIn(el, startCallback, endCallback){
  el.style.opacity = 0;
  typeof startCallback === "function" && startCallback();

  (function fade() {
    var val = parseFloat(el.style.opacity);
    val = Math.round((val + 0.1) * 10) / 10;
    if (val > 1) {
      typeof endCallback === "function" && endCallback();
    } else {
      el.style.opacity = val;
      requestAnimationFrame(fade);
    }
  })();
}
