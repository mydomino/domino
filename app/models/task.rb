# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  icon        :string
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cta_link    :string
#  cta_text    :string
#  default     :boolean          default(FALSE)
#




class Task < ActiveRecord::Base
  has_many :recommendations, as: :recommendable, dependent: :destroy
  has_many :dashboards, through: :recommendations, source: :recommendable

  ICON_OPTIONS = ['energy', 'heat', 'vehicle']
  validates_inclusion_of :icon, :in => ICON_OPTIONS

  scope :default, -> { where(default: true) }


end
