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

      // $('.welcome-tour-bg').css({
      //   position: "fixed",
      //   zIndex: 9999,
      //   top: "-5000px",
      //   right: "-5000px",
      //   bottom: "-5000px",
      //   left: "-5000px",
      //   background: "rgba(43, 46, 56, 0.9)"
      // });

      $('#wt-back').on('click', function(){
        secondModal.close();
        $('#first').fadeIn(function(){
          firstModal.open();
        });
      });

      // firstModal.open();

      // // Remove remodal plugin overlay
      // // Else theres a glitch effect between modal transitions
      // $('.remodal-overlay').remove();

      // $('#first .btn').on('click', function(){
      //   $(this).parent().fadeOut(function() {
      //     firstModal.close();
      //     secondModal.open();
      //   });
      // });

      // $('#second .btn').on('click', function(){
      //   $('#second').fadeOut(function() {
      //     $('.welcome-tour-bg').fadeOut(function() {
      //       intro = introJs();
      //       intro.setOptions({
      //         showStepNumbers: false
      //       });
      //       intro.start();
      //       intro.oncomplete(setTourDoneCookie);
      //       intro.onexit(setTourDoneCookie);
      //     });
      //   });
      // });
      
      Shepherd.on('show', function(o) {   
        let el = $(o.step.options.attachTo.split(' ')[0]);                                        
        let width = el.outerWidth() + 10;
        let height = el.outerHeight() + 10;                                                         
        let offset = el.offset();

          $('html, body').animate({
              scrollTop: el.offset().top - 32
            },
            400,
            $.noop
          );

        return $('.shep-overlay').show().css({
          position: 'absolute',                                                                
          width,                                                                        
          height,
          'box-shadow': '0px 0px 4px 4px rgba(0,0,0,0.5) inset, 0px 0px 0px 10000px rgba(0,0,0,0.5)',
          top: offset.top - 5,                                                                 
          left: offset.left - 5,                                                               
          'z-index': 1000000                                                                  
        });
      });  

      Shepherd.on('inactive', () => $('.shep-overlay').hide());

      let tour = new Shepherd.Tour({
        defaults: {
          classes: 'shepherd-theme-arrows',
          scrollTo: false
        }
      });

      tour.addStep('Food Impact', {
        title: 'Food Impact',
        text: 'See how diet affects carbon footprint',
        attachTo: '.fat-module bottom',
        classes: 'shepherd shepherd-open shepherd-theme-arrows shepherd-transparent-text',
        buttons: [
          {
            text: 'Next',
            classes: 'btn btn-sm btn-primary',
            action: tour.next
          }
        ]
      });

      tour.addStep('Clean Score', {
        title: 'Clean Score',
        text: 'Clean score for the week',
        attachTo: '.clean-score right',
        classes: 'shepherd shepherd-open shepherd-theme-arrows shepherd-transparent-text',
        buttons: [
          {
            text: 'Next',
            classes: 'btn btn-sm btn-primary',
            action: tour.next
          }
        ]
      });

      tour.addStep('Member benefits', {
        title: 'Member Benefits',
        text: 'Clean score for the week',
        attachTo: '.member-benefits top',
        classes: 'shepherd shepherd-open shepherd-theme-arrows shepherd-transparent-text',
        buttons: [
          {
            text: 'Exit',
            classes: 'btn btn-sm btn-primary',
            action: function() {
              return tour.hide();
            }
          }
        ]
      });

      tour.start();
    }
  };
});