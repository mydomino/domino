modulejs.define('myhome_tour', function(){
  return {
    mobile: null,
    modals: [],
    tourComplete: false,
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

      var remodalOpts = {closeOnOutsideClick: false, closeOnEscape: false}
      // Remodal dialog instances
      firstModal = $firstModal.remodal(remodalOpts);
      secondModal = $secondModal.remodal(remodalOpts);
      thirdModal = $thirdModal.remodal(remodalOpts);

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
        var fourthModal = $fourthModal.remodal(remodalOpts);
        this.modals.push({remodalInstance: fourthModal, jQInstance: $fourthModal});
      }

      // reset display
      $('.remodal-wt').css('display', 'inline-block');
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
          benefitsIntro,
          that;

      that = this;
      intro = introJs();
      introStep = 0;

      cleanScoreIntro = "<p class='bold'>Check out your clean score</p>" +
        "<p>This is calculated from your food challenge log. The lower your Foodprint, the better your grade.</p>";

      fatIntro =  "<p class='bold'>Here's your food challenge</h2>" +
        "<p>Join and compete with your teammates to see the impact you can make.</p>";

      leaderBoardIntro = "<p class='bold'>Your competition</p>" +
        "<p>See where you stand compared to your teammates. Can you rise to the top?</p>"

      benefitsIntro = "<p class='bold'>Your member perks</h2>" +
        "<p>Check out the cool offerings you receive as a MyDomino member!";
      
      // Push element intro content into data attributes where they are digested by introJs
      $('#fat-module').attr('data-intro', fatIntro);
      $('#clean-score').attr('data-intro', cleanScoreIntro);
      $('#benefits-introjs-wrapper').attr('data-intro', benefitsIntro);
      $('#leader-board').attr('data-intro', leaderBoardIntro);

      intro.setOptions({
        disableInteraction: true,
        showStepNumbers: false,
        exitOnEsc: false,
        exitOnOverlayClick: false
      });

      intro.oncomplete(function() {
        that.tourComplete = true;
        that.showSkipTriggers();
        $.get("profile/welcome-tour-complete", $.noop)
      });

      intro.onchange(function(targetElement) {
        introStep += 1;
        
        if(introStep === 4) {
          $('.introjs-skipbutton').css('display', 'inline-block');
        }
      });

      intro.start();

      if(that.tourComplete) {
        $('.introjs-skipbutton').css('display', 'inline-block');
      }

      // Workaround to prevent multiple overlays should
      // a user go through the tour multiple times
      $('.introjs-overlay').not(':first').remove();
    },
    showSkipTriggers: function(){
      $('.skip-for-now').removeClass('hidden');
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
            that.showSkipTriggers();
            $.get("profile/welcome-tour-complete", $.noop)
          }
        });
      });
      // END Module event handlers

    } // end start
  } // end return
}); // end modulejs def
