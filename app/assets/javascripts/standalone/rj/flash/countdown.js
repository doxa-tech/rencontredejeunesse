var count = $("#countdown-text");
var countdown = countdown(new Date(2019, 04, 07), function(ts) {
  count.text( minTwoDigit(ts.hours) + ":" + minTwoDigit(ts.minutes) + ":" + minTwoDigit(ts.seconds));
}, countdown.HOURS|countdown.MINUTES|countdown.SECONDS);

function minTwoDigit(str) {
  str = str.toString();
  if(str.length != 2) {
    return "0" + str;
  } else {
    return str;
  }
}