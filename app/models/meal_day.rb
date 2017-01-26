# == Schema Information
#
# Table name: meal_days
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  date             :datetime
#  carbon_footprint :float
#
# Indexes
#
#  index_meal_days_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_bef09397d1  (user_id => users.id)
#

class MealDay < ActiveRecord::Base
  belongs_to :user
  has_many :meals, dependent: :destroy

  validates :user, :date, :carbon_footprint, presence: :true
end
