modulejs.define('notification_settings', function () {
  return (function() {
    var $inputs,
        $timezone;
    $timezone = $('#timezone');

    $timezone.on('change', function(){

    });
    
    $inputs = $('#notifications').find('input[type=checkbox], select');

    $inputs.on('change', function(e){
      var $notification = $(e.target).parent();

      var notificationId = $notification.data('notification-id');
      var checked = $notification.find('input[type=checkbox]').is(':checked');
      var time = $notification.find('select').val();

      $.ajax({
        type: "POST",
        data: {notification_id: notificationId, checked: checked, time: time},
        url: '/notification_users',
        dataType: 'json',
        success: function(data) {
          console.log(data);
        }
      });
    });
  })();
});