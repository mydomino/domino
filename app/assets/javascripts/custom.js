var logoColors = {
  startColors: {
    text: 'white',
    penguin: 'white'
  },
  scrollColors: {
    text: '#666',
    penguin: '#00ccff'
  }
}
var navbarScroll = function(startColor, scrollColor){
  //initial state
  $('#logo-text > *').css('fill',logoColors.startColors.text)
  $('#logo-penguin > *').css('fill', logoColors.startColors.penguin);
  $('.navbar-element').css('color', startColor);
  $(window).scroll(function() {
      var scrollTop = $(this).scrollTop();
      if ( scrollTop > 35) {
        $('#logo-text > *').css('fill',logoColors.scrollColors.text)
        $('#logo-penguin > *').css('fill', logoColors.scrollColors.penguin);
        $('#navbar').css({'background-color':'#FFFFFF', 'box-shadow': '0 1px 1px 1px #f1f1f1'});
        $('.navbar-element').css('color', scrollColor);
        // $('#link-login').addClass('btn-secondary');
        // $('#link-login').removeClass('btn-white');

      }else{
        $('#logo-text > *').css('fill', logoColors.startColors.text);
        $('#logo-penguin > *').css('fill', logoColors.startColors.penguin);
        $('#navbar').css({'background-color':'transparent', 'box-shadow' : 'none'});
        $('.navbar-element').css('color', startColor);
        // $('#link-login').addClass('btn-white');
        // $('#link-login').removeClass('btn-secondary');
      }
    });
}

var setFixedFooter = function(){
  console.log('setting fixed footer');
  $('#footer').css({'position': 'absolute', 'left': 0, 'right': 0, 'bottom': 0});
}