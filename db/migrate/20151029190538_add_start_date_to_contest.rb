class AddStartDateToContest < ActiveRecord::Migration
  def change
    add_column :contests, :start_date, :date
  end
end
