class AddCtaFieldsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :cta_link, :string
    add_column :tasks, :cta_text, :string
  end
end