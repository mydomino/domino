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
$( signupInit ); // For direct page loads
$( document ).on( 'page:load', signupInit ); // For following links

function track_lead_creation()
{
  ga('send', 'event', 'lead', 'created');
  _fbq.push(['track','6031072723663',{}]);
  heap.track('lead creation', {});
}
