$( window ).scroll( function( event ) {
    var scroll = $( window ).scrollTop();
    if( scroll == 0 ) {
        $( 'body.index .navbar, body.getstarted .navbar' )
            .removeClass( 'scrolled' );
    } else {
        $( 'body.index .navbar, body.getstarted .navbar' )
            .addClass( 'scrolled' );
    }
});