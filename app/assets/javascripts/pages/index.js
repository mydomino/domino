window.MyDomino = window.MyDomino || {};
window.MyDomino.pages = window.MyDomino.pages || {};

window.MyDomino.pages["pages-index"] = function(){
  var iframe = $('iframe')[0];
  var player = $f(iframe);
  // When the player is ready/loaded, add a finish event listener
  player.addEvent('ready', function() {
    player.addEvent('finish', onFinish);
  });

  function onFinish(id) {
    $('#video-modal').fadeOut();
    player.api('unload');
    $('body').removeClass('lock-position');
  }
  $('.fa-play-circle').on('click', function(){
    $('#video-modal').fadeIn();
    $('body').addClass('lock-position');
    player.api('play');
  });

  $('#close-modal').on('click', function(){
    $('#video-modal').fadeOut();
    player.api('unload');
    $('body').removeClass('lock-position');
  });

  $('#btn-become-a-member').on('click', function(){
    $('html, body').animate({
        scrollTop: 0
      },
      1000,
      function(){ $('#profile_first_name').focus(); }
    );
  });

  // Name and email form validation
  nameAndEmailFormValidate();

  $('.slick').slick({
    centerMode: true,
    centerPadding: '20%',
    slidesToShow: 1,
    arrows: false,
    autoplay: true,
    autoplaySpeed: 4000,
    focusOnSelect: true,
    responsive: [
      {
        breakpoint: 640,
        settings: {
          centerPadding: '8%'
        }
      }
    ]
  });
};
