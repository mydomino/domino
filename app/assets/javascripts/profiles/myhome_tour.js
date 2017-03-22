modulejs.define('myhome_tour', function(){
  return {
    startTour: function(start) {
      if(!start) return;
      if(Cookies.get('welcometour') === 'finished') return;

      function setTourDoneCookie() {
        Cookies.set('welcometour', 'finished');
      }

      $('.welcome-tour-bg').css({
        position: "fixed",
        zIndex: 9999,
        top: "-5000px",
        right: "-5000px",
        bottom: "-5000px",
        left: "-5000px",
        background: "rgba(43, 46, 56, 0.9)"
      });

      var firstModal = $('#first').remodal();
      var secondModal = $('#second').remodal();
      var thirdModal = $('#third').remodal();
      
      firstModal.open();

      // Remove remodal plugin overlay
      // Else theres a glitch effect between modal transitions
      $('.remodal-overlay').remove();

      $('#first').on('click', function(){
        $(this).parent().fadeOut(function() {
          secondModal.open();
        });
      });

      $('#second').on('click', function(){
        $(this).parent().fadeOut(function() {
          thirdModal.open();
        });
      });

      $('#third').on('click', function(){
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