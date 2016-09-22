require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def product
    @product ||= Product.new
  end

  def test_valid
    assert product.valid?
  end
end
