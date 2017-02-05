// Google Analytics code to work with Turbolniks 5

this.GoogleAnalytics = (function() {
  function GoogleAnalytics() {}

  GoogleAnalytics.load = function() {
    var firstScript, ga;
    window._gaq = [];
    window._gaq.push(["_setAccount", GoogleAnalytics.analyticsId()]);
    window._gaq.push(['_setAllowAnchor', true]);
    ga = document.createElement("script");
    ga.type = "text/javascript";
    ga.async = true;
    ga.src = ("https:" === document.location.protocol ? "https://ssl" : "http://www") + ".google-analytics.com/ga.js";
    firstScript = document.getElementsByTagName("script")[0];
    firstScript.parentNode.insertBefore(ga, firstScript);
    if (typeof Turbolinks !== 'undefined' && Turbolinks.supported) {
      return document.addEventListener("turbolinks:load", (function() {
        return GoogleAnalytics.trackPageview();
      }), true);
    } else {
      return GoogleAnalytics.trackPageview();
    }
  };

  GoogleAnalytics.trackPageview = function(url) {
    if (!GoogleAnalytics.isLocalRequest()) {
      if (url) {
        window._gaq.push(["_trackPageview", url]);
      } else {
        window._gaq.push(["_trackPageview"]);
      }
      return window._gaq.push(["_trackPageLoadTime"]);
    }
  };

  GoogleAnalytics.isLocalRequest = function() {
    return GoogleAnalytics.documentDomainIncludes("local");
  };

  GoogleAnalytics.documentDomainIncludes = function(str) {
    return document.domain.indexOf(str) !== -1;
  };

  GoogleAnalytics.analyticsId = function() { return 'UA-38967567-8' };

  return GoogleAnalytics;

})();

GoogleAnalytics.load();
