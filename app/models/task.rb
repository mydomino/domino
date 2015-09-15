class Task < ActiveRecord::Base
  ICON_OPTIONS = ['energy', 'heat', 'vehicle', 'leaf']
  validates_inclusion_of :icon, :in => ICON_OPTIONS


end