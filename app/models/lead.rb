# == Schema Information
#
# Table name: leads
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  email                  :string
#  phone                  :string
#  address                :string
#  city                   :string
#  state                  :string
#  zip_code               :integer
#  ip                     :string
#  source                 :string
#  referer                :string
#  start_time             :datetime
#  campaign               :string
#  browser                :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  saved_to_zoho          :boolean
#  latitude               :float
#  longitude              :float
#  geocoded               :boolean
#  get_started_id         :integer
#  subscribe_to_mailchimp :boolean
#







class Lead < ActiveRecord::Base
end
