
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



function signupInit() {
    /**
     * Animate scroll directly to form anchor
     */
    $('a[href*=#]:not([href=#])').click(function() {
        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {

            var target = $(this.hash);
            var navheight = $('.navbar').height() + 20;
            target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top - navheight
                }, 800);
                return false;
            }
        }
    });
}
function track_lead_creation()
{
    ga('send', 'event', 'lead', 'created');
}
$( signupInit ); // For direct page loads
$( document ).on( 'page:load', signupInit ); // For following links
