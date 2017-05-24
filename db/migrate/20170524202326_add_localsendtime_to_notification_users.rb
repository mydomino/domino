class AddLocalsendtimeToNotificationUsers < ActiveRecord::Migration
  def change
    add_column :notification_users, :local_send_time, :integer
    add_column :notification_users, :sent_at, :datetime
  end
end
