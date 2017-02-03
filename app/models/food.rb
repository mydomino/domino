# == Schema Information
#
# Table name: foods
#
#  id           :integer          not null, primary key
#  food_type_id :integer
#  size         :float
#  meal_day_id  :integer
#
# Indexes
#
#  index_foods_on_food_type_id  (food_type_id)
#  index_foods_on_meal_day_id   (meal_day_id)
#
# Foreign Keys
#
#  fk_rails_457a970eb0  (food_type_id => food_types.id)
#

class Food < ActiveRecord::Base
  belongs_to :food_type
  belongs_to :meal_day

  validates :food_type, :meal, presence: true
end
