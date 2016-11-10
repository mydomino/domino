require 'httparty'
require 'json'
require 'crack'
require 'date'


class DHHtp
	include HTTParty

	#debug_output STDOUT


	def initialize(host_ip)
		@host_ip = host_ip

		# set the base URL 
    self.class.base_uri(@host_ip)

    paswd = ENV['WP_password']
    Rails.logger.info "paswd is: #{paswd}"

    # set digest authentication
    self.class.digest_auth('owner', paswd)
	end



	def get_posts(query_options)

	  Rails.logger.info "Getting Posts from Dreamhost with WP REST API V2...\n"

	  # set the base URL 
	  #self.class.base_uri(@host_ip)

	  #paswd = ENV['egauge_password']
    #Rails.logger.info "paswd is: #{paswd}"

    # set digest authentication
	  #self.class.digest_auth('owner', paswd)

	  #url = "http://#{@host_ip}/cgi-bin/egauge?tot&inst&teamstat&v1"
    
    Rails.logger.info "\nQuery options is: #{query_options}"

    
    response = self.class.get("/wp-json/wp/v2/posts", query: query_options)
    #response = self.class.get(url)
    Rails.logger.info "\nParams sent to URL is: #{response.request.last_uri.to_s}"

	  if response.success?
      response
    else
      raise response.response
    end
  
  end


  def get_post_by_id(id, query_options)

    Rails.logger.info "Getting Posts from Dreamhost with WP REST API V2...\n"
    Rails.logger.info "\nQuery options is: #{query_options}"

    
    response = self.class.get("/wp-json/wp/v2/posts/#{id}", query: query_options)
    #response = self.class.get(url)
    Rails.logger.info "\nParams sent to URL is: #{response.request.last_uri.to_s}"

    if response.success?
      response
    else
      raise response.response
    end
  
  end


  def display_posts(response)

     # convert JSON string to hash
    posts = JSON.parse(response.body)

    Rails.logger.info "Total #{posts.size} posts:"

    posts.each do |i|

      Rails.logger.info "\n\n======================================"
      Rails.logger.info "POST title: #{i['title']['rendered']}"
      Rails.logger.info "POST ID: #{i['id']}"

      # format date 
      date = DateTime.parse(i['date'])
      formatted_date = date.strftime('%a %b %d %H:%M:%S %Z %Y')
      
      Rails.logger.info "POST date: #{formatted_date}"
      Rails.logger.info "POST slug: #{i['slug']}"
      Rails.logger.info "POST type: #{i['type']}"
      Rails.logger.info "POST link: #{i['link']}"
      Rails.logger.info "POST excerpt: #{i['excerpt']['rendered']}"    
      Rails.logger.info "POST content: #{i['content']['rendered']}"
      
    end

  end



end