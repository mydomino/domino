modulejs.define('myhome_tour', function(){
  return function() {
    var firstModal = $('.remodal#first').remodal();
    var secondModal = $('.remodal#second').remodal();
    var thirdModal = $('.remodal#third').remodal();
    
    firstModal.open();

    $('.remodal-overlay').remove();

    $('#first .remodal-confirm').on('click', function(){
      $(this).parent().fadeOut(function() {
        secondModal.open();
      });
    });

    $('#second .remodal-confirm').on('click', function(){
      $(this).parent().fadeOut(function() {
        thirdModal.open();
      });
    });

    $('#third .remodal-confirm').on('click', function(){
      thirdModal.close();
      thirdModal.destroy();
      $('.welcome-tour-bg').fadeOut(function() {
        introJs().start();
      });
    });
  };
});