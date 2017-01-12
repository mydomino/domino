modulejs.define('new_org_member', function () {
  return function(){
    var $btnSignUp,
        $email,
        $firstName,
        $lastName,
        $pw,
        $pwConfirmation,
        $orgId,
        $emailSection,
        $msgFormFeedback,
        $namePwSectionj,
        $pEmail;

    // jQuerified elements
    $btnSignUp = $('#btn-sign-up');
    $email = $('#email');
    $firstName = $('#first_name');
    $lastName = $('#last_name');
    $pw = $('#password');
    $pwConfirmation = $('#password-confirmation');
    $orgId = $('#organization_id');

    $emailSection = $('#email-section');
    $msgFormFeedback = $('#msg-form-feedback');
    $namePwSection = $('#name-and-password-section');

    // Parsleyfied elements
    $pEmail = $email.parsley();

    $btnSignUp.on('click', function(e){
      e.preventDefault();

      // Check email server side
      if ($btnSignUp.attr('value') === 'Continue') {
        $pEmail.validate();

        if($pEmail.isValid()){
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
              } else {
                $emailSection.hide('slow', function(){
                  $msgFormFeedback.html('Please set name password').slideDown();
                  $namePwSection.show('slow');
                  $btnSignUp.attr('value', 'Sign up');
                });
              }
            }
          });
        }
        
      }
      // Submit name and password data to server
      else {
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
    });
  };
});