class RenameColumnsNotificationUsers < ActiveRecord::Migration
  def change
    rename_column :notification_users, :time, :send_hour
    rename_column :notification_users, :local_send_time, :server_send_hour
  end
end
