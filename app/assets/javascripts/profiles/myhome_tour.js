modulejs.define('myhome_tour', function(){
  return {
    startTour: function(start, mobile) {
      
      // Skip tour if start argument is false
      if(!start) return;

      var setTourDoneCookie,
          remodalOpts,
          firstModal,
          secondModal,
          thirdModal,
          mobile,
          modals,
          $firstModal,
          $secondModal,
          $thirdModal,
          $welcomeTourBg,
          intro,
          cleanScoreIntro,
          fatIntro;

      mobile = mobile;

      // Options for remodal dialog boxes
      remodalOpts = {
        closeOnOutsideClick: false,
        closeOnEscape: false
      }

      // Jquerified elements
      $firstModal = $('#first');
      $secondModal = $('#second');
      $thirdModal = $('#third');

      // Remodal dialog instances
      firstModal = $firstModal.remodal(remodalOpts);
      secondModal = $secondModal.remodal(remodalOpts);
      thirdModal = $thirdModal.remodal(remodalOpts);

      $welcomeTourBg = $('.welcome-tour-bg');

      modals = [{
                  remodalInstance: firstModal,
                  jQInstance: $firstModal
                },
                {
                  remodalInstance: secondModal,
                  jQInstance: $secondModal
                },
                { remodalInstance: thirdModal,
                  jQInstance: $thirdModal
                }];

      // If user is on mobile device, add fourth modal to modal collection
      if(mobile) {
        $fourthModal = $('#fourth');
        fourthModal = $fourthModal.remodal(remodalOpts);
        modals.push({remodalInstance: fourthModal, jQInstance: $fourthModal})
      }

      // BEGIN module event handlers
      // Go back to previous modal
      $('.wt-back').on('click', function(){
        var currStep = $(this).data('step');
        var prevModal = modals[currStep - 1];

        modals[currStep].jQInstance.fadeOut(200, function() {
          modals[currStep].remodalInstance.close();

          prevModal.jQInstance.fadeIn(50, function(){
            prevModal.remodalInstance.open();
          });
        });
      });

      // Go to next modal
      $('.wt-next').on('click', function() {
        var currStep = $(this).data('step');
        var nextModal = modals[currStep + 1];

        modals[currStep].jQInstance.fadeOut(200, function(){
          modals[currStep].remodalInstance.close();

          nextModal.jQInstance.fadeIn(50, function(){
            nextModal.remodalInstance.open();
          })
        });
      });

      // End remodal portion of tour
      // Start introJs portion of tour
      $('.wt-finish').on('click', function(){
        var currStep = $(this).data('step');
        modals[currStep].jQInstance.fadeOut(function() {
          $welcomeTourBg.fadeOut(function() {
            firstModal.destroy();
            secondModal.destroy();
            thirdModal.destroy();

            if(mobile) {
              fourthModal.destroy();
            } 
            else {
              // Show intro js tour for non mobile devices
              intro.setOptions({
                showStepNumbers: false,
                exitOnEsc: false,
                exitOnOverlayClick: false
              });
              intro.start();
            }
          });
        });
      });

      // Remodal portion of welcome tour background overlay
      $welcomeTourBg.css({
        position: "fixed",
        zIndex: 9999,
        top: "-5000px",
        right: "-5000px",
        bottom: "-5000px",
        left: "-5000px",
        background: "rgba(43, 46, 56, 0.9)"
      });

      // Start tour
      firstModal.open();
      
      // Remove remodal plugin overlay
      // Else theres a glitch effect between modal transitions
      $('.remodal-overlay').remove();

      // Intro js initialization and configuration
      if(!mobile) {
        intro = introJs();

        // Element intro content
        cleanScoreIntro = "<p class='bold'>Your clean score</p>" +
                          "<p>Earn points in this competition and rise to the top of your company leaderboard by staying below the average American’s Carbon Foodprint.</p>";

        fatIntro =  "<p class='bold'>Let’s start with food</h2>" +
                    "<p>Join the food challenge and compete with your co-workers to see how big an impact you can make.</p>";

        benefitsIntro = "<p class='bold'>Member benefits</h2>" +
                        "<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Laboriosam, numquam ea. Eveniet, optio est perspiciatis dicta assumenda iure, ad nulla quis nemo iste veritatis aspernatur quisquam a commodi. Eum, commodi.</p>";               
        
        // Push element intro content into data attributes where they are digested by introJs
        $('#fat-module').attr('data-intro', fatIntro);
        $('#clean-score').attr('data-intro', cleanScoreIntro);
        $('#member-benefits').attr('data-intro', benefitsIntro);
      }
    }
  };
});