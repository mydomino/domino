# == Schema Information
#
# Table name: meal_types
#
#  id             :integer          not null, primary key
#  caloric_budget :integer
#  name           :string
#

class MealType < ActiveRecord::Base
  enum name: [:breakfast, :lunch, :dinner]

  validates :caloric_budget, :name, presence: true
end
