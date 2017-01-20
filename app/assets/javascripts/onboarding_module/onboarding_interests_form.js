modulejs.define('onboarding_interests_form', function(){
  return function(){
    // BEGIN module scope variable definitions and initializations
    var $btnInterest;

    $btnInterest = $('.btn-interest');
    // END module scope variable definitions and initializations

    // BEGIN module event handlers

    $btnInterest.on('click', function(){
      $(this).toggleClass('btn-interest-active');
      var target = '#' + $(this).data('target');
      $(target).prop('checked', function( i, val ) {
        return !val;
      });
    });
    // END module event handlers

    // Allow submit button to be pressed only once
    singleSubmit();

    // For mobile viewports, scroll to top
    $(window).scrollTop(0);
  };
});