class NotificationUsersController < ApplicationController

  #post /notification_users
  def create
    notification_id = params[:notification_id].to_i
    checked = params[:checked] == 'true'
    time = params[:time].to_i
    notification_user = NotificationUser.find_by(user: current_user, notification_id: notification_id)
    
    if(notification_user)
      if(!checked)
        notification_user.destroy
      elsif(notification_user.time != time)
        notification_user.update(time: time)
      end
    elsif(checked)
      notification_user = NotificationUser.create(user: current_user, time: time, notification_id: notification_id)
    end

    render json: { message: "Success"}, status: 200
  end

  # /timezone_update/ XmlHttpRequest
  # Purpose: To update NoticationUser.local_send_time when user timezone is updated
  def timezone_update
    @tz = params[:profile][:time_zone]
    @notifications = current_user.notification_users

    if !@notifications.empty?
      @notifications.each do |n|
        send_at_hour = (n.time - Time.now.in_time_zone(@tz).utc_offset / (60*60))%24
        n.update(local_send_time: send_at_hour)
      end
      render json: { message: "Notifications updated successfully."}, status: 200
    else
      render json: { message: "No notifications to update."}, status: 200
    end
  end

end
