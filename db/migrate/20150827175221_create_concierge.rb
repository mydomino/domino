class CreateConcierge < ActiveRecord::Migration
  def change
    create_table :concierges do |t|
      t.string :name
      t.string :email
      t.string :picture
    end
  end
end
