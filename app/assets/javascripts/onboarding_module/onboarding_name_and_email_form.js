modulejs.define('onboarding_name_and_email_form', function(){
  return function(){
    // BEGIN module scope variable definitions and initializations
    var $btnSubmit,
        $form,
        $pForm;

    $form = $('.simple_form');
    $btnSubmit = $form.find('input[type=submit]');

    $pForm =  $form.parsley({
                errorClass: "error",
                errorsWrapper: '<div class="invalid-message red inline right"></div>',
                errorTemplate: '<span></span>',
                successClass: null
              });

    // END module scope variable definitions and initializations

    // BEGIN module event handlers
    $btnSubmit.on('click', function(e) {
      e.preventDefault();
      $pForm.validate();

      if ($pForm.isValid()) {
        $form.submit();
      }
    });
    // END module event handlers

  };
});