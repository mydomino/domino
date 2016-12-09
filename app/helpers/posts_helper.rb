require 'date'

module PostsHelper

  CATEGORY_SLUG_TO_TITLE = {  'clean-power': 'Clean power', 
                              'getting-around': 'Getting around', 
                              'heating-and-cooling': 'Heating & cooling', 
                              'energy-efficiency': 'Energy efficiency'
                              }.stringify_keys

	def format_post_date(date_str)

		# format date 
    date = DateTime.parse(date_str)
    formatted_date = date.strftime('%B %-d, %Y')

    return formatted_date

	end

  def extract_post_thumbnail_src(post_json_data, size)
    (post_json_data['better_featured_image']['media_details']['sizes'].has_key? size)\
    ? post_json_data['better_featured_image']['media_details']['sizes'][size]['source_url']\
    : post_json_data['md_thumbnail']
  end


end
