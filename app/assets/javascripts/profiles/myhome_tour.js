modulejs.define('myhome_tour', function(){
  return function() {
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
        introJs().start();
      });
    });
  };
});