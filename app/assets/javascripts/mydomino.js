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

var nameAndEmailFormValidate = function(){
  var $requiredFields = $('.required-field');

  $('#btn-begin-onboard').on('click', function(e){
    e.preventDefault();
    console.log('btn begin onboard clicked');
    if (validateRequiredFields($requiredFields)){
      $(".simple_form").submit();
    }
  });

  var validateRequiredFields = function($fields){
    $.each($fields,function(index, value){
      patt = new RegExp($(value).data('reg'));
      if(patt.test($(value).val()) == false  ){
        $(value).addClass('invalid-field');
        $($(value).data('target')).removeClass('display-none');
      }
    });
    return $('.invalid-field').length == 0 ? true : false;
  };

  $requiredFields.bind('input change propertychange', function(){
    patt = new RegExp($(this).data('reg'));
    if(patt.test($(this).val()) == true ){
      $(this).removeClass('invalid-field');
      $($(this).data('target')).addClass('display-none');
    }
  });

  //submit buttons may not be pushed multiple times
  $(".simple_form").submit(function() {
    $(this).submit(function() {
      return false;
    });
    ga('send', 'event', 'Onboarding', 'Get started', 'Onboarding started', 0);
    return true;
  });
};
