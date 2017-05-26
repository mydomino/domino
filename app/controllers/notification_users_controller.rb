class NotificationUsersController < ApplicationController

  #post /notification_users
  def create_update_or_destroy
    notification_id = params[:notification_id].to_i
    checked = params[:checked] == 'true'
    send_hour = params[:time].to_i
    notification_user = NotificationUser.find_by(user: current_user, notification_id: notification_id)
    
    if(notification_user)
      if(!checked)
        notification_user.destroy
      elsif(notification_user.send_hour != send_hour)
        notification_user.update(send_hour: send_hour)
      end
    elsif(checked)
      notification_user = NotificationUser.create(user: current_user, send_hour: send_hour, notification_id: notification_id)
    end

    render json: { message: "Success"}, status: 200
  end

  # /timezone_update/ XmlHttpRequest
  # Purpose: To update NoticationUser.server_send_hour when user timezone is updated
  def timezone_update
    @tz = params[:profile][:time_zone]
    @notifications = current_user.notification_users

    if !@notifications.empty?
      @notifications.each do |n|
        server_send_hour = (n.send_hour - Time.now.in_time_zone(@tz).utc_offset / (60*60))%24
        n.update(server_send_hour: server_send_hour)
      end
      render json: { message: "Notifications updated successfully."}, status: 200
    else
      render json: { message: "No notifications to update."}, status: 200
    end
  end

end
