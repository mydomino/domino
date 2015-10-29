class Contest < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end