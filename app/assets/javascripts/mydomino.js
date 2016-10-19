/* Namespaced MyDomino application javascript */

var MyDomino = {
  conciergeToolsJS: function(){
    $('[data-disclosure]').click(function(e){
      $(e.currentTarget).children('[data-details]').toggle();
    });
    setTimeout(function(){
      $('.alerts').hide('slow');
    }, 2000);
  }, 
  onboardingFormsJS: {
    interests: function(){
      // unbind events prior to binding; to prevent multiple binds 
      // due to turbolinks view rendering mechanisms
      $('.btn-interest').unbind('click');
      $('.btn-interest').on('click', function(){
        $(this).toggleClass('btn-interest-active');
        var target = '#' + $(this).data('target');
        $(target).prop('checked', function( i, val ) {
          return !val;
        });
      });  
      singleSubmit();
      //mobile
      $(window).scrollTop(0);
    },
    livingSituation: function(){

    }
  }
};

//submit buttons may not be pushed multiple times
var singleSubmit = function(){
  $("form").unbind('submit');
  $("form").on('submit', function() {
      $(this).submit(function() {
        return false;
      });
      return true;
  });
};
