class Task < ActiveRecord::Base
  has_many :recommendations, as: :recommendable, dependent: :destroy
  has_many :dashboards, through: :recommendations, source: :recommendable

  ICON_OPTIONS = ['energy', 'heat', 'vehicle']
  validates_inclusion_of :icon, :in => ICON_OPTIONS


end