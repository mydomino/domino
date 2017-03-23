class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.datetime :datetime_sign_in

      t.timestamps null: false

    end

    # add unique index to columns
    add_index(:group_users, [:user_id, :group_id], unique: true)

  end
end
