$(document).ready(function()
{
  $('[data-toggle="modal"]').click(function(e){
   var target = $(e.currentTarget).data('target');
   $(target).show();
   $('body').append('<div class="modal-bg"></div>');
   $('body').addClass('overflow-hidden');
  });
  $('.modal').click(function(e)
  {
    if($(e.originalEvent.target).parents('.modal-content').length < 1)
    {
      $('.modal-bg').remove();
      $('.modal').hide();
      $('body').removeClass('overflow-hidden');
    }
  });
});