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
  has_many :foods, dependent: :destroy

  enum category: {
    fruits: 0, 
    vegetables: 1, 
    dairy: 2, 
    grains: 3, 
    fish_poultry_pork: 4, 
    beef_lamb: 5
  }
  
  validates :category, :carbon_footprint, :icon, :name, presence: true
end
