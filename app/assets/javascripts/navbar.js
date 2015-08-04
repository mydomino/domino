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
  $( '.navbar' ).addClass( 'scrolled animated slideInDown fixed' );
}

function hideNavBar()
{
  $( '.navbar' ).removeClass( 'scrolled animated slideInDown fixed' );
}