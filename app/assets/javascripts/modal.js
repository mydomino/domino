$(document).ready(function()
{
  $('[data-toggle="modal"]').click(function(e){
    var target = $(e.currentTarget).data('target');
    reveal_modal(target);
  });
  $('.modal').click(function(e)
  {
    if($(e.originalEvent.target).parents('.modal-content').length < 1)
    {
      hide_modal(); 
    }
  });
  $('[data-dismiss=modal]').click(function(){
    hide_modal();
  })
});

function reveal_modal(target)
{
  $(target).show().addClass("animated fadeIn");
  $('body').append('<div class="modal-bg fixed top-0 bottom-0 left-0 right-0"></div>');
  $('body').addClass('overflow-hidden');
}

function hide_modal()
{
  $('.modal-bg').remove();
  $('.modal').hide();
  $('body').removeClass('overflow-hidden');
}