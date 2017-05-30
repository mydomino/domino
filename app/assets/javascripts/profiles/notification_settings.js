modulejs.define('notification_settings', function () {
  return (function() {
    var $inputs,
        $timezone;
        
    $timezone = $('#profile_time_zone');

    $timezone.on('change', function(){
     $.ajax({
        type: "PATCH",
        data: {profile: {time_zone: $timezone.val()}},
        url: $timezone.data('action'),
        dataType: 'json',
        success: function(data) {
          console.log(data);
        }
      });
     $.ajax({
        type: "POST",
        data: {profile: {time_zone: $timezone.val()}},
        url: 'notication_users/tz-update',
        dataType: 'json',
        success: function(data) {
          console.log(data);
        }
      });
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