
function analyticsInit() {
  if ( window._gaq != null ) {
    return _gaq.push( [ '_trackPageview' ] );
  } else if ( window.pageTracker != null ) {
    return pageTracker._trackPageview();
  }
  (function() {
    var _fbq = window._fbq || (window._fbq = []);
    if (!_fbq.loaded) {
      var fbds = document.createElement('script');
      fbds.async = true;
      fbds.src = '//connect.facebook.net/en_US/fbds.js';
      var s = document.getElementsByTagName('script')[0];
      s.parentNode.insertBefore(fbds, s);
      _fbq.loaded = true;
    }
  })();
  window._fbq = window._fbq || [];

}

$( analyticsInit ); // For direct page loads
$( document ).on( 'page:load', analyticsInit ); // For following links