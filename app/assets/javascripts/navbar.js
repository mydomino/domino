$( window ).scroll( function( event ) {
  var scroll = $( window ).scrollTop();
  if( scroll < 300 ) 
  {
    hideNavBar();
  }
  else
  {
    showNavBar();
  }
});

function showNavBar()
{
  $( '.navbar.roll-down' ).addClass( 'scrolled animated slideInDown fixed' );
}

function hideNavBar()
{
  $( '.navbar.roll-down' ).removeClass( 'scrolled animated slideInDown fixed' );
}