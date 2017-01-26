# == Schema Information
#
# Table name: foods
#
#  id           :integer          not null, primary key
#  food_type_id :integer
#  portion      :float
#  meal_id      :integer
#
# Indexes
#
#  index_foods_on_food_type_id  (food_type_id)
#  index_foods_on_meal_id       (meal_id)
#
# Foreign Keys
#
#  fk_rails_457a970eb0  (food_type_id => food_types.id)
#  fk_rails_f8d8f2b0fc  (meal_id => meals.id)
#


class Food < ActiveRecord::Base
  belongs_to :food_type
  belongs_to :meal

  validates :food_type, :meal, presence: true
end
