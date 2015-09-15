$(document).ready(
function(){
  $('*[data-reveal-next]').click(function(event){
    var target = $(event.target)
    target.parent().contents().filter(function(){
        return (this.nodeType == 3);
    }).remove();
    target.hide();
    var reveal_class = target.data('reveal-next')
    target.next('.' + reveal_class).show();
  })
});