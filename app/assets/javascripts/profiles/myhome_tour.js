modulejs.define('myhome_tour', function(){
  return {
    mobile: null,
    start: null,
    modals: null,
    initModals: function() {
      var remodalOpts,
          firstModal,
          secondModal,
          thirdModal,
          $firstModal,
          $secondModal,
          $thirdModal;

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

      this.modals = [];
      this.modals = [
        {
          remodalInstance: firstModal,
          jQInstance: $firstModal
        },
        {
          remodalInstance: secondModal,
          jQInstance: $secondModal
        },
        { remodalInstance: thirdModal,
          jQInstance: $thirdModal
        }
      ];

      if(this.mobile) {
        var $fourthModal = $('#fourth');
        var fourthModal = $fourthModal.remodal(remodalOpts);
        this.modals.push({remodalInstance: fourthModal, jQInstance: $fourthModal});
      }
      // reset display
      $('.remodal').css('display', 'inline-block');

    },
    init: function(mobile) {
      this.mobile = mobile;

      $('#wt-link').on('click', $.proxy(this.start, this, true));

    },
    startIntroJs: function() {
      var intro = introJs();
      var introStep = 0;

      intro.setOptions({
        showStepNumbers: false,
        exitOnEsc: false,
        exitOnOverlayClick: false
      });

      var cleanScoreIntro = "<p class='bold'>Your clean score</p>" +
        "<p>Earn points in this competition and rise to the top of your company leaderboard by staying below the average American’s Carbon Foodprint.</p>";

      var fatIntro =  "<p class='bold'>Let’s start with food</h2>" +
        "<p>Join the food challenge and compete with your co-workers to see how big an impact you can make.</p>";

      var benefitsIntro = "<p class='bold'>Member benefits</h2>" +
        "<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Laboriosam, numquam ea. Eveniet, optio est perspiciatis dicta assumenda iure, ad nulla quis nemo iste veritatis aspernatur quisquam a commodi. Eum, commodi.</p>";               

      // Push element intro content into data attributes where they are digested by introJs
      $('#fat-module').attr('data-intro', fatIntro);
      $('#clean-score').attr('data-intro', cleanScoreIntro);
      $('#member-benefits').attr('data-intro', benefitsIntro);
      
      intro.start();
      
      // Workaround to prevent multiple overlays should
      // a user go through the tour multiple times
      $('.introjs-overlay').not(':first').remove();
      
      intro.oncomplete(function() {
        console.log('intro complete');
      });

      intro.onbeforechange(function(targetElement) {
        introStep += 1;
        
        if(introStep === 2) {
          $('.introjs-skipbutton').css('display', 'inline-block');
        }
      });
    },
    start: function(start) {
      if(!start) return;

      this.initModals();
      
      var that = this;

      var $welcomeTourBg,
          modals,
          mobile;

      mobile = this.mobile;
      modals = this.modals;

      $welcomeTourBg = $('.welcome-tour-bg');
      
      $welcomeTourBg.css({
        display: "block",
        position: "fixed",
        zIndex: 9999,
        top: "-5000px",
        right: "-5000px",
        bottom: "-5000px",
        left: "-5000px",
        background: "rgba(43, 46, 56, 0.9)"
      });

      modals[0].remodalInstance.open();
      
      // Hide remodal plugin overlay
      // Else theres a glitch effect between modal transitions
      $('.remodal-overlay').css("visibility", "hidden");

      // BEGIN module event handlers
      // Go back to previous modal
      $('.wt-back').on('click', function(){
        var currStep = $(this).data('step');
        var currModal = modals[currStep];
        var prevModal = modals[currStep - 1];

        currModal.jQInstance.fadeOut(200, function() {
          currModal.remodalInstance.close();

          prevModal.jQInstance.fadeIn(50, function(){
            prevModal.remodalInstance.open();
          });
        });
      });

      // Go to next modal
      $('.wt-next').on('click', function(){
        var currStep = $(this).data('step');
        var currModal = modals[currStep];
        var nextModal = modals[currStep + 1];

        currModal.jQInstance.fadeOut(200, function(){
          currModal.remodalInstance.close();

          nextModal.jQInstance.fadeIn(50, function(){
            nextModal.remodalInstance.open();
          });
        });
      });

      // End remodal portion of tour
      // Start introJs portion of tour
      $('.wt-finish').on('click', function(){
        var currStep = $(this).data('step');
        var currModal = modals[currStep];
        currModal.remodalInstance.close();
        $welcomeTourBg.fadeOut(function() {
          if(!mobile) {
            that.startIntroJs();
          }
        });
      });

    } // end start
  } // end return
}); // end modulejs def
