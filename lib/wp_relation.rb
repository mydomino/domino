require 'dh_htp_wp_rest_api'   #find this in lib folder


class WPRelation

  def initialize(page, post_per_page)
    puts "\n\n****** initialize is called.\n\n"

    @page = page.to_i
    @limit = post_per_page
    @dh = DHHtp.new(DHHtp::HOST_IP)
  end

  def current_page

    puts "\n\n****** current_page is called.\n\n"

    @page
  end

  def total_pages

    puts "\n\n****** total_pages is called.\n\n"

    tot_pages = 0

    begin

      response = get_posts_response
      total_posts, tot_pages = @dh.get_pagination_params(response.headers)
  
    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end

    return(tot_pages)

  end


  def limit_value
    puts "\n\n****** limit_value is called.\n\n"

    @limit
  end


  def offset

    puts "\n\n****** offset is called.\n\n"
    (@page - 1) * @limit
  end


  def all

    puts "\n\n****** all is called.\n\n"

    response = get_posts_response

    # convert JSON string to hash
    posts = JSON.parse(response.body)

  end

  #def execute(sql)
  #  PG.connect(...).exec(sql)
#
  #  begin
#
  #    
  #    query_param = {page: @page, per_page: @limit}
  #    
  #    response = @dh.get_posts(query_param)
  #
  #    #Rails.logger.info "\nResponse is: #{response}\n"
  #    #@dh.display_posts(response)
#
  #    # convert JSON string to hash
  #    @posts = JSON.parse(response.body)
#
  #    @total_posts, @total_pages = @dh.get_pagination_params(response.headers)
  #    
  #
  #  rescue => e
  #    Rails.logger.info "\nError! #{e}\n"        
  #  end
#
  #end

  def get_posts_response

    begin

      
      query_param = {page: @page, per_page: @limit}
      
      response = @dh.get_posts(query_param)
      
  
    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end

  end





#  def to_sql
#    <<-SQL.strip_heredoc
#    select distinct on (applicant_number) applicant_number, created_at, account_id from sms_messages
#    where account_id = 147
#    order by applicant_number, created_at DESC
#    limit #{@limit} offset #{offset}
#SQL
#  end

  def to_count_sql

    puts "\n\n****** to_count_sql is called.\n\n"

    total_posts = 0

    begin

      response = get_posts_response
      total_posts, tot_pages = @dh.get_pagination_params(response.headers)
  
    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end

    return(total_posts)
    
  end

end