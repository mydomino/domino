modulejs.define('member_profile', function () {
  return function(avgElectricalBill){
    var currentPasswordValid,
        updatedFields,
        showPasswordForm,
        hidePasswordForm,
        submitChangedPassword,
        $pwForm,
        $profileForm,
        $currPw,
        $pCurrPw,
        $pPwForm,
        $pProfileForm,
        $pwSubmit,
        $btnProfileSubmit,
        $msgProfileUpdate,
        $msgPasswordUpdate,
        $btnChangePw,
        $btnCancelChangePw;

    // Variable initializations
    currentPasswordValid = false;
    updatedFields = {}; // Payload with updated info to send to server

    // jQuerified elements
    $pwForm = $('.edit_password');
    $currPw = $('#current_password');
    $btnChangePw = $('#btn-change-password');
    $btnCancelChangePw = $('#btn-cancel-change-password');

    $profileForm = $('.edit_profile');
    $btnProfileSubmit = $profileForm.find('input[type=submit]');
    $msgProfileUpdate = $profileForm.find('#msg-profile-update');
    $msgPasswordUpdate = $('#msg-password-update');
    // Parsleyfied password fields
    $pCurrPw = $('#current_password').parsley();

    // Parsleyfied forms
    $pPwForm = $('.edit_password').parsley({
                        errorClass: "error",
                        errorsWrapper: '<div class="invalid-message inline right"></div>',
                        errorTemplate: '<span></span>',
                        successClass: null
                    });

    $pProfileForm = $('.edit_profile').parsley({
                            errorClass: "error",
                            errorsWrapper: '<div class="invalid-message inline right"></div>',
                            errorTemplate: '<span></span>',
                            successClass: null
                        });



    /*------------- END Module variable declarations and definitions-----------*/

    /*------------- BEGIN Module configurations--------------------------------*/

    /*------------- BEGIN UI configurations -----------------------------------*/
    // Mask phone and zip code input
    $('#profile_zip_code').mask('00000');
    $('#profile_phone').mask('(000) 000-0000');

    // jQuery UI Slider for average electrical bill
    $( ".slider" ).slider({
      range: "min",
      animate: "fast",
      max: 250,
      value: avgElectricalBill,
      create: function( event, ui ) {
        $('#slider > span').css({cursor: 'pointer', outline: '0'});
      },
      slide: function( event, ui ) {
        $('#slider_val').html(ui.value);
        $('#profile_avg_electrical_bill').val(ui.value);
        setUpdatedField($($(event.target).attr('target')));
        // enableSubmit();
      }
    });
    /*------------- END UI configurations -----------------------------------*/

    /*------------- BEGIN Profile form configurations -----------------------------------*/
    // Fields to bind input change handler
    var profileFields = {
      first_name: $('#profile_first_name'),
      last_name: $('#profile_last_name'),
      phone: $('#profile_phone'),
      address: $('#profile_address_line_1'),
      city: $('#profile_city'),
      state: $('#profile_state'),
      zip_code: $('#profile_zip_code'),
      time_zone: $('#profile_time_zone')
    };

    // Bind input event handler to profile fields
    for (var key_name in profileFields){
      profileFields[key_name].on('input', function(event){
        setUpdatedField($(this));
      });
    }

    // Event handler for housing radio buttons
    $('input[type=radio]').change(function() {
      setUpdatedField($(this));
    });

    // /setUpdatedField/ On a profile field change, update updatedFields
    var setUpdatedField = function($field){
      console.log("setUpdatedField is called")
      field_name = $field.attr('name');
      field_value = $field.val();
      updatedFields[field_name] = field_value;
    };

    // Validate profile info fields on submit
    $btnProfileSubmit.on('click', function(event){
      event.preventDefault();
      if(Object.keys(updatedFields).length > 0){
        $pProfileForm.validate();
      }
    });

    // On profile form success, send updatedFields payload to server
    $pProfileForm.on('form:success', function(){
      console.log("Hello, Yong")
      $.ajax({
        type: "POST",
        data: { _method:'PATCH', updated_fields: updatedFields},
        url: $profileForm.attr('action'),
        dataType: 'json',
        success: function(msg) {
          $pProfileForm.reset();
          // $btnProfileSubmit.attr('disabled', true);
          $msgProfileUpdate.show('slow');
          setTimeout(function(){ $msgProfileUpdate.hide('slow'); }, 5000);
        }
      });
    });
    /*------------- END Profile form configurations -----------------------------------*/

    /*------------- BEGIN Password form configurations -----------------------------------*/
    // Custom Parsley validator: new password cannot be the same as current
    window.Parsley.addValidator('notequalto', {
      requirementType: 'string',
      validateString: function(val, elem) {
        return val !== $(elem).val();
      },
      messages: {
        en: 'Your new password is the same as your current password'
      }
    });

    // /showPasswordForm/ animate revealing of the password form elements
    showPasswordForm = function(){
      $pwForm.show('slow', function(){
        $btnChangePw
          .addClass('btn-primary btn-primary--hover')
          .removeClass('btn-secondary btn-secondary--hover');

        $btnChangePw.bind('click', submitChangedPassword);
      });
      $btnCancelChangePw.fadeIn('slow');
      $btnChangePw.unbind('click');
    };

    // /hidePasswordForm/ animate hiding of the password form elements and reset form elements
    hidePasswordForm = function(){
      $pwForm.hide('slow', function(){
        // clear password input fields on cancel
        $pwForm.find('input[type=password]').val("");

        // Reset parsley styles
        $pPwForm.reset();
        $pCurrPw.reset();
        $btnChangePw
          .removeClass('btn-primary btn-primary--hover')
          .addClass('btn-secondary btn-secondary--hover');
      });
      $btnCancelChangePw.fadeOut('slow');
      $btnChangePw
        .unbind('click', submitChangedPassword)
        .bind('click', showPasswordForm);
    };

    submitChangedPassword = function(){
      $pPwForm.validate();

      $.ajax({
        url: "profile/verify-current-password",
        data: {'current_password': $('#current_password').val()},
        dataType: 'json',
        async: false,
        type: 'GET',
        success: function(data){
          response = true;
          currentPasswordValid = true;
          $pCurrPw.removeError('current_password_error', {updateClass: true});
          if($pPwForm.isValid()){
            var updated_password = $('#new_password_confirmation').val();
            $.ajax({
              type: "POST",
              url: '/profile/update-password',
              data: { _method:'PATCH',  updated_password: updated_password},
              dataType: 'json',
              success: function() {
                hidePasswordForm();
                $msgPasswordUpdate.show('slow');
                setTimeout(function(){ $msgPasswordUpdate.hide('slow'); }, 5000);
              }
            });
          }
        },
        error: function(data){
          currentPasswordValid = false;
          if(!$currPw.hasClass('error')){
            $pCurrPw.addError('current_password_error', {message: 'Current password is incorrect' , assert: false, updateClass: true});
          }
        }
      });
    };

    // Change password event handling
    $btnChangePw.on('click', showPasswordForm);
    $btnCancelChangePw.on('click', hidePasswordForm);
    /*------------- END Password form configurations -----------------------------------*/
    /*------------- END Module configurations-------------------------------------------*/
  };
});
