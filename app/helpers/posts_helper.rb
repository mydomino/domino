require 'date'

module PostsHelper

	def format_post_date(date_str)

		# format date 
    date = DateTime.parse(date_str)
    formatted_date = date.strftime('%B %-d, %Y')

    return formatted_date

	end
end
