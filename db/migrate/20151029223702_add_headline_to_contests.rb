
class AddHeadlineToContests < ActiveRecord::Migration
  def change
    add_column :contests, :headline, :string
  end
end