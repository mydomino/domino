$( window ).scroll( function( event ) {
    var scroll = $( window ).scrollTop();
    if( scroll == 0 ) {
        $( 'body.index .navbar' ).removeClass( 'scrolled' );
    } else {
        $( 'body.index .navbar' ).addClass( 'scrolled' );
    }
});