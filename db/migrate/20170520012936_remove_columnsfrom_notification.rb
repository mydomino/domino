class RemoveColumnsfromNotification < ActiveRecord::Migration
  def change
  	remove_column :notifications, :day if column_exists?(:notifications, :day)
    remove_column :notifications, :time if column_exists?(:notifications, :time)
  end
end
