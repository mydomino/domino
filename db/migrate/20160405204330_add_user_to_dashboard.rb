class AddUserToDashboard < ActiveRecord::Migration
  def change
    add_reference :dashboards, :user, index: true, foreign_key: true
  end
end
