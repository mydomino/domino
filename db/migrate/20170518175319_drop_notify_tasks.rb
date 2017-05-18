class DropNotifyTasks < ActiveRecord::Migration
  def change
  	drop_table :notify_tasks if ActiveRecord::Base.connection.table_exists? 'notify_tasks'
  end
end
