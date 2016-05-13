var navbarScroll = function(startColor, scrollColor){
  $('.navbar-element').css('color', startColor);
  $(window).scroll(function() {
      var scrollTop = $(this).scrollTop();
      if ( scrollTop > 70) { 
        $('#navbar').css({'background-color':'#FFFFFF', 'box-shadow': '0 1px 1px 1px #f1f1f1'});
        $('.navbar-element').css('color', scrollColor)
      }else{
        $('#navbar').css({'background-color':'transparent', 'box-shadow' : 'none'});
        $('.navbar-element').css('color', startColor)
      }
    });
}

var setFixedFooter = function(){
  console.log('setting fixed footer');
  $('#footer').css({'position': 'absolute', 'left': 0, 'right': 0, 'bottom': 0});
}