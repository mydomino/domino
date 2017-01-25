# == Schema Information
#
# Table name: food_types
#
#  id               :integer          not null, primary key
#  category         :integer
#  carbon_footprint :float
#  icon             :string
#  name             :string
#

class FoodType < ActiveRecord::Base
  has_a :food

  enum category: [:fruits, :vegetables, :dairy, :grains, :fish_poultry_pork, :beef_lamb]
  validates :category, :carbon_footprint, :icon, :name, presence: true
end
