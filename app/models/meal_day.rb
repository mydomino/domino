class MealDay < ActiveRecord::Base
  belongs_to :user

  validates :user, :date, :carbon_footprint, presence: :true
end