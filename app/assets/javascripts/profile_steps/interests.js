window.MyDomino = window.MyDomino || {};
window.MyDomino.pages = window.MyDomino.pages || {};

window.MyDomino.pages["profile_steps-interests"] = function(){   
  $('.btn-interest').on('click', function(){
    $(this).toggleClass('btn-interest-active');
    var target = '#' + $(this).data('target');
    $(target).prop('checked', function( i, val ) {
      return !val;
    });
  });  
  singleSubmit();
  //mobile
  $(window).scrollTop(0);
};