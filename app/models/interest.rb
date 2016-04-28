class Interest < ActiveRecord::Base
  belongs_to :profile
  belongs_to :offering
end
