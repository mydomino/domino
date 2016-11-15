require 'httparty'
require 'json'
require 'crack'
require 'date'
require 'nokogiri'

class DHHtp
	include HTTParty

	#debug_output STDOUT
  HOST_IP = 'mydomino.dreamhosters.com'


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

      Rails.logger.info "\n\n\n======================================"
      Rails.logger.info "POST title: #{i['title']['rendered']}\n"
      Rails.logger.info "POST ID: #{i['id']}\n"
      Rails.logger.info "Author Name: #{i['author_meta']['display_name']}\n"


      # format date 
      date = DateTime.parse(i['date'])
      formatted_date = date.strftime('%b %d, %Y')
      
      
      Rails.logger.info "POST date: #{formatted_date}\n"
      Rails.logger.info "POST slug: #{i['slug']}\n"
      Rails.logger.info "POST type: #{i['type']}\n"
      Rails.logger.info "POST link: #{i['link']}\n"
      Rails.logger.info "POST feature image URL: #{i['md_thumbnail']}\n"
      Rails.logger.info "POST excerpt: #{i['excerpt']['rendered']}\n"    
      Rails.logger.info "POST content: #{i['content']['rendered']}\n"

      #get the post image from its content
      html_doc = Nokogiri::HTML(i['content']['rendered'])
      #image_urls = html_doc.search('//img/@src').to_a
      image_urls = html_doc.xpath("//img/@src").collect {|item| item.value.strip}


      Rails.logger.info "Content Image URLs: #{image_urls.inspect}\n"
      
    end

  end

  
  def get_pagination_params(resp_headers)


      # retrieve the params from response headers
      #resp_headers = response.headers
      a = resp_headers['x-wp-total']
      b = resp_headers['x-wp-totalpages']

      # return the first element in the array for the params
      puts "Total posts: #{a}"
      puts "Total pages: #{b}"

      return ([a, b])
      
  end




end