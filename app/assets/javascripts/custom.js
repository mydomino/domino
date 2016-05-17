var navbarScroll = function(startColor, scrollColor){
  //initial state
  $('#logo-text').css('color', logoColors.startColors.text);
  $('#logo-penguin').css('color', logoColors.startColors.penguin);
  $('.navbar-element').css('color', startColor);
  $(window).scroll(function() {
      var scrollTop = $(this).scrollTop();
      if ( scrollTop > 70) { 
        $('#logo-text').css('color', logoColors.scrollColors.text);
        $('#logo-penguin').css('color', logoColors.scrollColors.penguin);
        $('#navbar').css({'background-color':'#FFFFFF', 'box-shadow': '0 1px 1px 1px #f1f1f1'});
        $('.navbar-element').css('color', scrollColor)
      }else{
        $('#logo-text').css('color', logoColors.startColors.text);
        $('#logo-penguin').css('color', logoColors.startColors.penguin);
        $('#navbar').css({'background-color':'transparent', 'box-shadow' : 'none'});
        $('.navbar-element').css('color', startColor)
      }
    });
}

var setFixedFooter = function(){
  console.log('setting fixed footer');
  $('#footer').css({'position': 'absolute', 'left': 0, 'right': 0, 'bottom': 0});
}