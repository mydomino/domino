# == Schema Information
#
# Table name: organizations
#
#  id           :integer          not null, primary key
#  name         :string
#  email        :string
#  phone        :string
#  fax          :string
#  company_url  :string
#  sign_up_code :string
#  join_date    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Organization < ActiveRecord::Base
	has_many :teams, dependent: :destroy
	has_many :users, dependent: :nullify
	has_many :subscriptions, dependent: :destroy

	validates :name, :presence => true
	
end
