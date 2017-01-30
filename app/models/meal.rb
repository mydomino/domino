# == Schema Information
#
# Table name: meals
#
#  id           :integer          not null, primary key
#  size         :integer
#  meal_day_id  :integer
#  meal_type_id :integer
#
# Indexes
#
#  index_meals_on_meal_day_id   (meal_day_id)
#  index_meals_on_meal_type_id  (meal_type_id)
#
# Foreign Keys
#
#  fk_rails_1b415a57bf  (meal_day_id => meal_days.id)
#  fk_rails_604de882b4  (meal_type_id => meal_types.id)
#


class Meal < ActiveRecord::Base
	has_many :foods, dependent: :destroy
  belongs_to :meal_day
  belongs_to :meal_type

  enum size: {small: 0, medium: 1, large: 2}

  validates :meal_day, :meal_type, :size, presence: true
end
