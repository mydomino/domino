class AmazonStorefront < ActiveRecord::Base
  has_many :recommendations
  belongs_to :concierge
  acts_as_url :lead_name

  def to_param
    url
  end
end