class RemoveAvailabilityIdFromProfiles < ActiveRecord::Migration
  def change
    remove_foreign_key :profiles, column: :availability_id
  end
end
