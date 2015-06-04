
function signupInit() {
    $( '.concierge button' ).click( function() {
        $( this ).text( "We've Received Your Request" );
        $( '.concierge .reserve').addClass( 'submitted' );
    });

    $( '.footer button').click( function() {
        $( this ).text( "Thanks!" );
        $( '.footer .mailing-list').addClass( 'submitted' );
    });

    $('a[href*=#]:not([href=#])').click(function() {
        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {

            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top
                }, 800);
                return false;
            }
        }
    });
}

$( signupInit ); // For direct page loads
$( document ).on( 'page:load', signupInit ); // For following links
