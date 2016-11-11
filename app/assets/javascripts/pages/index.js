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

  $('.slick').slick({
    centerMode: true,
    centerPadding: '20%',
    slidesToShow: 1,
    responsive: [
      {
        breakpoint: 768,
        settings: {
          arrows: false,
          centerMode: true,
          centerPadding: '40px',
          slidesToShow: 1
        }
      },
      {
        breakpoint: 480,
        settings: {
          arrows: false,
          centerMode: true,
          centerPadding: '40px',
          slidesToShow: 1
        }
      }
    ]
  });
};