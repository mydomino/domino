window.MyDomino = window.MyDomino || {};
window.MyDomino.pages = window.MyDomino.pages || {};

window.MyDomino.pages["profile_steps-living_situation"] = function(args){ 
  /* BEGIN form element JS */
  /* Geocoding */

  $(".geocode").geocomplete({ details: ".details", detailsAttribute: "data-geo" });

  $('.geocode').unbind("geocode:result");
  $('.geocode').bind("geocode:result", function(e, r) {
    $('#profile_state').val($('#span-state').html());
    $('#profile_city').val($('#span-city').html());
    $('#profile_zip_code').val($('#span-zipcode').html());
    $('#profile_address_line_1').val($('#span-street_number').html() + " " + $('#span-route').html());
    $requiredFields.change();
  });

  /*phone input hints*/
  $('.fa-question-circle-o, #why-phone').unbind('click');
  $('.fa-question-circle-o, #why-phone').on('click', function(){
    $('.fa-question-circle-o').toggleClass('blue');
    $('#phone-input-hint').toggleClass('display-none');
  });

  // /* average electricity bill slider */
  $( "#slider" ).slider({
    range: "min",
    animate: "fast",
    max: 250,
    value: args.livingSituation.avgElectricalBill,
    create: function( event, ui ) {
      $('#slider > span').css({cursor: 'pointer', outline: '0'});
    },
    slide: function( event, ui ) {
      $('#slider_val').html(ui.value);
      $('#profile_avg_electrical_bill').val(ui.value);
    }
  });

  /* housing toggle button */
  $('.btn-group .btn').unbind('click');
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
  /* END form element JS */

  /* BEGIN form validation logic */
  var $requiredFields = $('.required-field');
  var invalidFields = [];

  /* validate required fields prior to form submission */
  $('input[value="Next"]').on('click', function(e){
    e.preventDefault();

    if (validateRequiredFields($requiredFields)){ 
      $("form").submit();
    }
  });

  /* custom error message for city, state, zip fields */
  function formatErrorMsg($group) {
    switch (invalidFields.length) {
      case 1:
        str = invalidFields[0] + ' is required.';
        break;
      case 2:
        str = invalidFields[0] + ' and ' + invalidFields[1] + ' are required.';
        break;
      case 3:
        str = invalidFields[0] + ', ' + invalidFields[1] + ', & ' + invalidFields[2] + ' are required.';
        break;
    }

    $($group.data('target')).html(str);
    $($group.data('target')).removeClass('display-none');
  }

  var validateRequiredFields = function($fields){
    invalidFields = [];
    $.each($fields, function(index, value){
      patt = new RegExp($(value).data('reg'));
      if(!patt.test($(value).val())){
        $(value).addClass('invalid-field');

        if($(value).data('error-target')){
          var target = $(value).data('error-target');
          $(target).addClass('btn-secondary--invalid');
        }

        if($(value).data('msg-group')){
          var $group = $($(value).data('msg-group'));
          invalidFields.push($(value).data('label'));
          formatErrorMsg($group);
          
        } else {
          $($(value).data('target')).removeClass('display-none');
        }
      }
    });
    return $('.invalid-field').length == 0 ? true : false;
  };

  //state machine
  $requiredFields.unbind('input change propertychange');
   /* Mask phone number */
   /* Mask after unbind, else mask won't take effect */
  $("#profile_phone").mask("(999) 999-9999");

  $requiredFields.bind('input change propertychange', function(){
    patt = new RegExp($(this).data('reg'));

    if(patt.test($(this).val())){
      $(this).removeClass('invalid-field');

      if ($(this).attr('id')=='profile_phone' && $('.fa-question-circle-o').hasClass('blue')){
        $('.fa-question-circle-o').trigger('click');
      }

      if ($(this).data('msg-group')){
        var $group = $($(this).data('msg-group'));
        var msgGroup = $(this).data('msg-group');
        var target = $(msgGroup).data('target');
        var label = $(this).data('label');
        var validIndex = invalidFields.indexOf(label);

        if(validIndex != -1){
          invalidFields.splice(validIndex, 1);
          formatErrorMsg($group);
        }

        var $msgGroup = $('*[data-msg-group="' + msgGroup + '"]');
        var numFields = $msgGroup.length;
        var numValidFields = 0;

        $.each($msgGroup,function(index, value){
          patt = new RegExp($(value).data('reg'));
          if(patt.test($(value).val()) == false){
            return false;
          } else {
            numValidFields += 1;
          }
        });

        if(numValidFields == numFields){
          $(target).addClass('display-none');
        }
      } else {
        if($(this).data('error-target')){
          var target = $(this).data('error-target');
          $(target).removeClass('btn-secondary--invalid');
        }
        $($(this).data('target')).addClass('display-none');
      }
    }
  });
  /* END form validation logic */

  singleSubmit();

  $(window).scrollTop(0);
}