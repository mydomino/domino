modulejs.define('notification_settings', function () {
  return (function() {
    var $inputs;

    $inputs = $('#notifications').find('input[type=checkbox], select');

    $inputs.on('change', function(e){
      var $notification = $(e.target).parent();
      
      var checked = $notification.find('input[type=checkbox]').is(':checked');
      var time = $notification.find('select').val();

    });
  })();
});