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
