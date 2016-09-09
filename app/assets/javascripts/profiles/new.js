window.MyDomino = window.MyDomino || {};
window.MyDomino.pages = window.MyDomino.pages || {};

window.MyDomino.pages["profiles-new"] = function(){
  //housing toggle button
  $('.btn-group .btn').on('click', function(){
    $('.btn-group .btn').not(this).removeClass('btn-secondary--active');
    $(this).toggleClass('btn-secondary--active');
    if( $('.btn-secondary--active').size() > 0 ){
      var val = $(this).data("value");
      $('#profile_housing').val(val).trigger('change');
    }else{
      $('#profile_housing').val("").trigger('change');
    }
  });
};