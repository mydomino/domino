class Action < ActiveRecord::Base
  ICON_OPTIONS = ['energy', 'heat', 'vehicle']
  validates_inclusion_of :icon, :in => ICON_OPTIONS
end