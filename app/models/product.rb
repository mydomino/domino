class Product < ActiveRecord::Base
  has_many :recommendations, as: :recommendable, dependent: :destroy
  has_many :dashboards, through: :recommendations, source: :recommendable

  validates_format_of :url, :with => /amazon.com\/.*[dg]p\/(?:product\/)?(\w*)/, message: "Not a valid Amazon product URL"

  after_create :retrieve_amazon_details

  scope :default, -> { where(default: true) }

  #to be called by delayed job
  def update_amazon_price
    response = query_amazon_api product_id
    parsed_response = Nokogiri::XML(response.body)
    self.price = parsed_response.at_css("Price FormattedPrice").content
    self.save
  end

  private

  def retrieve_amazon_details
    product_id ||= extract_id_from_url
    response = query_amazon_api product_id
    parse_amazon_response response
  end

  def extract_id_from_url
    self.product_id = /amazon.com\/.*[dg]p\/(?:product\/)?(\w*)/.match(self.url)[1]
  end

  def query_amazon_api id
    request = Vacuum.new
    request.associate_tag = 'domino09d-20'
    response = request.item_lookup(
      query: {
        'ItemId' => id,
        'ResponseGroup' => 'Images,Offers,Small'
      }
    )
    return response
  end

  def update_price
    
  end

  def parse_amazon_response response
    parsed_response = Nokogiri::XML(response.body)
    self.xml = response.body
    self.name = parsed_response.at_css("Title").content
    self.url = parsed_response.at_css("DetailPageURL").content
    self.image_url = parsed_response.at_css("LargeImage URL").content
    self.price = parsed_response.at_css("Price FormattedPrice").content
    self.save
  end


end