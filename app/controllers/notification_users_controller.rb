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

end
