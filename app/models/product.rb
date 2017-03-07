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




require 'retries'
class Product < ActiveRecord::Base
  has_many :recommendations, as: :recommendable, dependent: :destroy
  has_many :dashboards, through: :recommendations, source: :recommendable

  validates_format_of :url, :with => /amazon.com\/.*[dg]p\/(?:product\/)?(\w*)/, message: "Not a valid Amazon product URL"

  after_create :retrieve_amazon_details

  scope :default, -> { where(default: true) }

  #to be called by delayed job
  def update_amazon_price
    #retries in case of 503 due to server overloading
    response = with_retries(:max_tries => 5, :max_sleep_seconds => 2.0 ){ query_amazon_api product_id }

    #amazon api allows only 1 api request/sec
    sleep 1
    parsed_response = Nokogiri::XML(response.body)
    begin
      self.price = !parsed_response.at_css('Price FormattedPrice').nil? ? parsed_response.at_css('Price FormattedPrice').text : parsed_response.at_css('FormattedPrice').text
    rescue StandardError => error
      #todo 
      #if this exception is encountered, the product is currently unavailable
      puts "Error is caught in update_amazon price method! Error is #{e.message}"
    end
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
    request.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
    request.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    request.associate_tag = 'domino09d-20'
    response = request.item_lookup(
      query: {
        'ItemId' => id,
        'ResponseGroup' => 'Large,Offers'
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
