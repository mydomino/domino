
function analyticsInit() {
    if ( window._gaq != null ) {
        return _gaq.push( [ '_trackPageview' ] );
    } else if ( window.pageTracker != null ) {
        return pageTracker._trackPageview();
    }
}

$( analyticsInit ); // For direct page loads
$( document ).on( 'page:load', analyticsInit ); // For following links