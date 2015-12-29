function fadeOut(el, startCallback, endCallback){
  el.style.opacity = 1;
  typeof startCallback === "function" && startCallback();

  (function fade() {
    if ((el.style.opacity -= .1) < 0) {
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
    if (!((val += .1) > 1)) {
      el.style.opacity = val;
      requestAnimationFrame(fade);
    } else {
      typeof endCallback === "function" && endCallback();
    }
  })();
}
