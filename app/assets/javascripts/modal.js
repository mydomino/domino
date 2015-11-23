$(document).ready(function()
{
  $('[data-toggle="modal"]').click(function(e){
   var target = $(e.currentTarget).data('target');
   $(target).show();
   $('body').append('<div class="modal-bg"></div>');
   $('body').addClass('overflow-hidden');
  });
  $('.modal').click(function()
  {
    $('.modal-bg').remove();
    $('.modal').hide();
    $('body').removeClass('overflow-hidden');
  });
  $('.modal .modal-content').click(function(e)
  {
    e.stopPropagation();
  })
});