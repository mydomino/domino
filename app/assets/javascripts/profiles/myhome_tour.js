modulejs.define('myhome_tour', function(){
  return {
    mobile: null,
    modals: null,
    initModals: function() {
      var $firstModal,
          $secondModal,
          $thirdModal,
          firstModal,
          secondModal,
          thirdModal;

      // Jquerified elements
      $firstModal = $('#first');
      $secondModal = $('#second');
      $thirdModal = $('#third');

      // Remodal dialog instances
      firstModal = $firstModal.remodal();
      secondModal = $secondModal.remodal();
      thirdModal = $thirdModal.remodal();

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

      // If user is on mobile device, create fourth modal elements
      if(this.mobile) {
        var $fourthModal = $('#fourth');
        var fourthModal = $fourthModal.remodal();
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
      var intro,
          introStep,
          cleanScoreIntro,
          fatIntro,
          leaderBoardIntro,
          benefitsIntro;

      intro = introJs();
      introStep = 0;

      cleanScoreIntro = "<p class='bold'>Your clean score</p>" +
        "<p>Earn points in this competition and rise to the top of your leaderboard by staying below the average American’s carbon foodprint.</p>";

      fatIntro =  "<p class='bold'>Let’s start with food</h2>" +
        "<p>Join the food challenge and compete with your teammates to see the impact you can make.</p>";

      leaderBoardIntro = "<p class='bold'>The Leaderboard</p>" +
       "<p>See where you stands compare to your teammates.</p>"

      benefitsIntro = "<p class='bold'>Member benefits</h2>" +
        "<p>Check out the cool offerings you receive as a MyDomino member!";
      
      // Push element intro content into data attributes where they are digested by introJs
      $('#fat-module').attr('data-intro', fatIntro);
      $('#clean-score').attr('data-intro', cleanScoreIntro);
      $('#member-benefits').attr('data-intro', benefitsIntro);
      $('#leader-board').attr('data-intro', leaderBoardIntro);

      intro.setOptions({
        showStepNumbers: false,
        exitOnEsc: false,
        exitOnOverlayClick: false
      });

      intro.oncomplete(function() {
        $.get("profile/welcome-tour-complete", $.noop)
      });

      intro.onchange(function(targetElement) {
        introStep += 1;
        
        if(introStep === 4) {
          $('.introjs-skipbutton').css('display', 'inline-block');
        }
      });

      intro.start();

      // Workaround to prevent multiple overlays should
      // a user go through the tour multiple times
      $('.introjs-overlay').not(':first').remove();
    },
    start: function(start) {
      if(!start) return;

      this.initModals();

      var $welcomeTourBg,
          modals,
          mobile,
          that;

      $welcomeTourBg = $('.welcome-tour-bg');
      modals = this.modals;
      mobile = this.mobile;
      that = this;
      
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

      // Start tour
      modals[0].remodalInstance.open();
     
      // Hide remodal plugin overlay
      // Else theres a glitch effect between modal transitions
      $('.remodal-overlay').css("visibility", "hidden");

      // BEGIN module event handlers
      // Allow users to skip modal portion of tour
      $('.skip-for-now').on('click', function(){
        var currStep = $(this).data('step');
        modals[currStep].remodalInstance.close();
        $welcomeTourBg.fadeOut()
      });

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
      // Start introJs portion of tour for non-mobile users
      $('.wt-finish').on('click', function(){
        var currStep = $(this).data('step');

        modals[currStep].remodalInstance.close();

        $welcomeTourBg.fadeOut(function() {
          if(!mobile) {
            that.startIntroJs();
          } 
          else {
            $.get("profile/welcome-tour-complete", $.noop)
          }
        });
      });
      // END Module event handlers

    } // end start
  } // end return
}); // end modulejs def
