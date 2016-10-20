/* Namespaced MyDomino application javascript */

var MyDomino = {
  conciergeToolsJS: function(){
    $('[data-disclosure]').click(function(e){
      $(e.currentTarget).children('[data-details]').toggle();
    });
    setTimeout(function(){
      $('.alerts').hide('slow');
    }, 2000);
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
