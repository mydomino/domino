modulejs.define('myhome_tour', function(){
  return {
    startTour: function(start) {
      if(!start) return;
      if(Cookies.get('welcometour') === 'finished') return;

      function setTourDoneCookie() {
        Cookies.set('welcometour', 'finished');
      }

      var remodalOpts = {
        closeOnOutsideClick: false,
        closeOnEscape: false
      }

      var firstModal = $('#first').remodal(remodalOpts);
      var secondModal = $('#second').remodal(remodalOpts);
      var thirdModal = $('#third').remodal(remodalOpts);

      $('.welcome-tour-bg').css({
        position: "fixed",
        zIndex: 9999,
        top: "-5000px",
        right: "-5000px",
        bottom: "-5000px",
        left: "-5000px",
        background: "rgba(43, 46, 56, 0.9)"
      });

      $('#wt-back').on('click', function(){
        secondModal.close();
        $('#first').fadeIn(function(){
          firstModal.open();
        });
      });

      firstModal.open();

      // Remove remodal plugin overlay
      // Else theres a glitch effect between modal transitions
      $('.remodal-overlay').remove();

      $('#first .btn').on('click', function(){
        $(this).parent().fadeOut(function() {
          firstModal.close();
          secondModal.open();
        });
      });

      $('#second .btn').on('click', function(){
        $(this).parent().fadeOut(function() {
          thirdModal.open();
        });
      });

      $('#third .btn').on('click', function(){
        thirdModal.close();
        thirdModal.destroy();
        
        $('.welcome-tour-bg').fadeOut(function() {
          intro = introJs().start();
          intro.oncomplete(setTourDoneCookie);
          intro.onexit(setTourDoneCookie);
        });
      });
    }
  };
});