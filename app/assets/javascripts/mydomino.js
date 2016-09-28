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