class AddSignupTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :signup_token, :string
    add_column :users, :signup_token_sent_at, :datetime
  end
end
