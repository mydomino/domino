modulejs.define('home', function () {
  return function(){
    // Begin module scope variable definition and initialization
    var $body,
        $playCircle,
        $videoModal,
        $closeModal,
        $txtInputFirstName,
        $btnBecomeAMember,
        iframe,
        player,
        onFinish;

    $body = $('body');
    $playCircle = $('.fa-play-circle');
    $videoModal = $('#video-modal');
    $closeModal = $('#close-modal');
    $txtInputFirstName = $('#profile_first_name');
    $btnBecomeAMember = $('#btn-become-a-member');
    iframe = $('iframe')[0];
    player = $f(iframe);

    // When the player is ready/loaded, add a finish event listener
    player.addEvent('ready', function() {
      player.addEvent('finish', onFinish);
    });

    // Begin /onFinish
    onFinish = function(id) {
      $videoModal.fadeOut();
      player.api('unload');
      $body.removeClass('lock-position');
    };
    // End /onFinish

    // Begin module scope event handlers
    $playCircle.on('click', function(){
      $videoModal.fadeIn();
      $body.addClass('lock-position');
      player.api('play');
    });

    $closeModal.on('click', function(){
      $videoModal.fadeOut();
      player.api('unload');
      $body.removeClass('lock-position');
    });

    $btnBecomeAMember.on('click', function(){
      $('html, body').animate({
          scrollTop: 0
        },
        1000,
        function(){ $txtInputFirstName.focus(); }
      );
    });
    // End module scope event handlers

    // Slick carousel
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
    // End Slick carousel
  };
});
