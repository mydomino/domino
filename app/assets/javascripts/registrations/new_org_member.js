modulejs.define('new_org_member', function (args) {
  return function() {

    // Begin module scope variable definitions and initializations
    var $btnSignUp,
        $email,
        $firstName,
        $lastName,
        $pw,
        $pwConfirmation,
        $orgId,
        $msgFormFeedback,
        $pForm,
        $namePwSection,
        $pNamePwFields,
        verifyEmail,
        createOrgMember;

    // jQuerified elements
    $btnSignUp = $('#btn-sign-up');
    $email = $('#email');
    $firstName = $('#first_name');
    $lastName = $('#last_name');
    $pw = $('#password');
    $pwConfirmation = $('#password-confirmation');
    $orgId = $('#organization_id');

    $msgFormFeedback = $('#msg-form-feedback');
    $namePwSection = $('#name-and-password-section');

    // Parsleyfied form elements
    $pForm =  $('form').parsley({
                errorClass: "error",
                errorsWrapper: '<div class="invalid-message inline right"></div>',
                errorTemplate: '<span></span>',
                successClass: null
              });

    // Begin method /verifyEmail/
    // Purpose: This method is used to send the user's submitted email to server.
    //   The server returns a message indicating whether or not a user account exists
    //   for the provided email address.
    //   If an account already exists, the user is informed an email with additional
    //   instructions for claiming their account has been sent.
    //   If an account doesn't already exist, the user is shown the name and password
    //   form
    verifyEmail = function() {
      $pForm.validate({group: 'email'});

      if($pForm.isValid({group: 'email'})){
        $.ajax({
          type: "GET",
          url: '/check-org-member-email',
          data: { 
                  organization_id: parseInt($orgId.val()),
                  email: $email.val() 
                },
          dataType: 'json',
          success: function(data) {
            if(data.message === 'account exists'){
              $msgFormFeedback.html('An email has been sent with instructions for claiming your account.').slideDown();
              $btnSignUp.attr('disabled', 'disabled');
              $btnSignUp.css('cursor', 'not-allowed');
            } else {
              $email.prop('disabled', true);
              $msgFormFeedback.html('Please set your name and password').slideDown();
              $namePwSection.slideDown('slow');
              $btnSignUp.attr('value', 'Sign up');
            }
          }
        });
      }
    }
    // End /verifyEmail/

    // Begin /createOrgMember/
    // Purpose: To submit a new member's name and password information to the server
    //   such that the appropriate user resources (User, Profile, Dashboard) may be allocated.
    createOrgMember = function() {
      $pForm.validate({group: 'name-pw'});
      if ( $pForm.isValid({group: 'name-pw'}) ) {
        $.ajax({
          type: "POST",
          url: '/create-org-member',
          data: { 
                  organization_id: $orgId.val(),
                  email: $email.val(),
                  first_name: $firstName.val(),
                  last_name: $lastName.val(),
                  password: $pw.val(),
                  password_confirmation: $pwConfirmation.val()
                },
          dataType: 'json',
          success: function(data) {
            window.location.replace('/dashboard');
          }
        });
      }
    }
    // End /createOrgMember/
    // End module scope variable definitions and initializations

    // Begin module event handlers
    $btnSignUp.on('click', function(e) {
      e.preventDefault();

      if ($btnSignUp.attr('value') === 'Continue') {
        verifyEmail();
      }
      else {
        createOrgMember();
      }
    });
    // End module event handlers

  };
});