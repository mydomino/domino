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

      // // Remove remodal plugin overlay
      // // Else theres a glitch effect between modal transitions
      $('.remodal-overlay').remove();

      $('#first .btn').on('click', function(){
        $('#first').fadeOut(function() {
          secondModal.open();
        });
      });

      $('#second .btn').on('click', function(){
        $('#second').fadeOut(function() {
          $('.welcome-tour-bg').fadeOut(function() {
            firstModal.destroy();
            secondModal.destroy();
            // tour.start();
            var intro = introJs().start();
          });
        });
      });
      
    }
  };
});