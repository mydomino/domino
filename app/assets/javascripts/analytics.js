
function analyticsInit() {
  //Heap
  window.heap=window.heap||[],heap.load=function(t,e){window.heap.appid=t,window.heap.config=e;var a=document.createElement("script");a.type="text/javascript",a.async=!0,a.src=("https:"===document.location.protocol?"https:":"http:")+"//cdn.heapanalytics.com/js/heap-"+t+".js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(a,n);for(var o=function(t){return function(){heap.push([t].concat(Array.prototype.slice.call(arguments,0)))}},p=["clearEventProperties","identify","setEventProperties","track","unsetEventProperty"],c=0;c<p.length;c++)heap[p[c]]=o(p[c])};
  if(!heap.loaded)
  {
    heap.load("1887691062");
  }
  //Google Analytics
  if ( window._gaq != null ) {
    return _gaq.push( [ '_trackPageview' ] );
  } else if ( window.pageTracker != null ) {
    return pageTracker._trackPageview();
  }
  //Facebook Conversion Tracking
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