class CreatePointsLogs < ActiveRecord::Migration
  def change
    create_table :points_logs do |t|
      t.date :point_date
      t.string :point_type
      t.string :desc
      t.integer :point
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
