# == Schema Information
#
# Table name: meal_types
#
#  id             :integer          not null, primary key
#  caloric_budget :integer
#  name           :integer
#


class MealType < ActiveRecord::Base
  enum name: {
    breakfast: 0, 
    lunch: 1, 
    dinner: 2
  }

  
  has_many :meals, dependent: :destroy
  
  validates :caloric_budget, :name, presence: true
  validates :name, uniqueness: true
end
