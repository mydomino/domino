# == Schema Information
#
# Table name: meal_days
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  date             :date
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
  has_many :foods, dependent: :destroy
  validates :user, :date, presence: :true

  def calculate_cf
    self.carbon_footprint = (self.foods.inject(0) {|sum, f| sum + (f.food_type.carbon_footprint * (f.size/100.0))}).round(2)
    self.save
  end

end
