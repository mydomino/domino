class CreateNotifyTasks < ActiveRecord::Migration
  def change
    create_table :notify_tasks do |t|
      t.string :name
      t.string :desc
      t.references :notification, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
