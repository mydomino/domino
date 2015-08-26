class AmazonProduct < ActiveRecord::Base
  after_create :retrieve_amazon_details

  private

  def retrieve_amazon_details
    request = Vacuum.new
    request.associate_tag = 'tag'
    response = request.item_lookup(
      query: {
        'ItemId' => product_id,
        'ResponseGroup' => 'Images,Offers,Small'
      }
    )
    parsed_response = Nokogiri::XML(response.body)
    self.xml = response.body
    self.url = parsed_response.at_css("DetailPageURL").content
    self.image_url = parsed_response.at_css("LargeImage URL").content
    #self.price = parsed_response.at_css("DetailPageURL").content
    self.save
  end
end