# == Schema Information
#
# Table name: partner_codes
#
#  id           :integer          not null, primary key
#  code         :string
#  partner_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#







class PartnerCode < ActiveRecord::Base
end
