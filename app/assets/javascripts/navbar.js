$( window ).scroll( function( event ) {
    var scroll = $( window ).scrollTop();
    if( scroll < 300 ) {
        $( 'body.index .navbar, body.getstarted .navbar' )
            .removeClass( 'scrolled animated slideInDown fixed' );
    } else {
        $( 'body.index .navbar, body.getstarted .navbar' )
            .addClass( 'scrolled animated slideInDown fixed' );
    }
});