require 'date'

module PostsHelper

	def format_post_date(date_str)

		# format date 
    date = DateTime.parse(date_str)
    formatted_date = date.strftime('%B %-d, %Y')

    return formatted_date

	end

  def extract_post_thumbnail_src(post_json_data)
    (post_json_data['_embedded']['wp:featuredmedia'][0]['media_details']['sizes'].has_key? 'maverick-medium-alt')\
    ? post_json_data['_embedded']['wp:featuredmedia'][0]['media_details']['sizes']['maverick-medium-alt']['source_url']\
    : post_json_data['md_thumbnail']
  end
end
