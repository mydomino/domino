class LegacyUser < ActiveRecord::Base
  validates :email, uniqueness: true
end
