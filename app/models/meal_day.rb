# == Schema Information
#
# Table name: meal_days
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  date             :date
#  carbon_footprint :float
#  points           :integer
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
  has_many :foods, dependent: :destroy
  validates :user, :date, presence: :true

  # Define averge CF constants (in grams of CO2e)
  AVG_DAILY_CF   = 7004
  BASELINE_CF    = 1064  # for oils, snacks & sugar, and drinks

  # Carbon footprint calculation formula:
  #   Average size (in Calories) of food type x Size (percentage) x Carbon footprint of that food type (g/Calories)
  def calculate_cf
    self.carbon_footprint = self.foods.inject(0) do |sum, f| 
      sum + (f.food_type.carbon_footprint * (f.size / 100.0) * f.food_type.average_size)
    end
    self.carbon_footprint += MealDay::BASELINE_CF # add baseline carbon emission (1064g)
    self.carbon_footprint = (self.carbon_footprint / 1000).round(2) # Convert from g to kg
    self.save
  end
end
