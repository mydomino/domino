# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  url         :string
#  product_id  :string
#  description :string
#  image_url   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  price       :string
#  xml         :string
#  name        :string
#  default     :boolean          default(FALSE)
#


require "test_helper"

class ProductTest < ActiveSupport::TestCase

  should have_many :recommendations
  #should have_many :dashboards




  def product
    @product ||= Product.new(url: 'http://www.amazon.com/Accutire-MS-4021B-Digital-Pressure-Gauge/dp/B0008')
  end

  def test_valid
    assert product.valid?
  end
end
