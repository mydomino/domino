modulejs.define('org_admin_dashboard', function () {
  return function() {

    /*------------- BEGIN Module variable declarations and initializations-----------*/
    var $btnAddEmployee,
        $addMemberForm,
        $msgAddMember,
        $memberCount,
        $pAddMemberForm,
        $pEmail,
        $email;

    // JQueryfied elements
    $memberCount = $('#member-count');
    $addMemberForm = $('.new_user');
    $btnAddEmployee = $('#btn-add-employee');
    $msgAddMember = $('#msg-add-member');
    $email = $addMemberForm.find('input[type=email]');
    
    // Parsleyfied elements
    $pAddMemberForm = $addMemberForm.parsley({
                              errorClass: "error",
                              errorsWrapper: '<div class="invalid-message inline right"></div>',
                              errorTemplate: '<span></span>',
                              successClass: null
                          });
    
    // We need to parsleyfy the email field to throw error states for already taken emails
    $pEmail = $email.parsley();

    /*------------- END Module variable declarations and initializations-----------*/

    /*------------- BEGIN Module event handlers -----------------------------------*/
    $btnAddEmployee.on('click', function(e){
      // Reset email field if its in error state, so only one error state can exist at time
      if($email.hasClass('error')){
        $pEmail.reset();
      };
      $pAddMemberForm.validate();
    });
    
    $pAddMemberForm.on('form:success', function(){
      var formData = {};
      
      // Create form data payload for posting to server
      $addMemberForm.find("input[name]").each(function (index, node) {
        formData[node.name] = node.value;
      });

      $.ajax({
        type: "POST",
        url: $addMemberForm.attr('action'),
        data: formData,
        dataType: 'json',
        success: function(msg) {
          // On successful member addition, reset parsley form, 
          // Clear input fields, update member count, display feedback message
          $pAddMemberForm.reset();
          var mc = msg.member_count;
          $memberCount.html(mc);
          $addMemberForm.find('input[type=text], input[type=email]').val("");
          $msgAddMember.fadeIn();
          setTimeout(function(){ $msgAddMember.fadeOut(); }, 5000);
        },
        error: function() {
          // Server side error: email already taken for user
          $pEmail.addError('email_taken_error', {message: 'Email already taken' , assert: false, updateClass: true});
        }
      });
    });
    /*------------- END Module event handlers -------------------------------------*/

  }
});