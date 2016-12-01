#require 'wp_relation' 
require 'dh_htp_wp_rest_api'

class PostsController < ApplicationController
  #before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_dream_host_instance
  #before_filter :verify_post_access


  def index

    begin
      query_params = {page: params[:page] || 1, per_page: params[:per_page] || 10}

      Rails.logger.debug "In index action, category param is #{params[:cat]}\n"

      #add a category if it is specified in the query
      if !params[:cat].nil?

        filt = {category_name: params[:cat]}
        query_params[:filter] = filt
      end

      response = @dh.get_posts(query_params)

      @posts = JSON.parse(response.body)
      @total_posts, @total_pages = @dh.get_pagination_params(response.headers)
      @paginatable_array = Kaminari.paginate_array((1..@total_posts.to_i).to_a).page(params[:page] || 1).per(10)
    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end
  end

  # GET /posts/1
  def show

    #@post_content, @title, @excerpt, @post_date, @author = ""
 
    begin

      post_id = params[:id]
      #Rails.logger.debug "Post id is #{post_id}\n"

      #categories = params[:cat]
      #Rails.logger.debug "categories param is #{categories.inspect}\n"

      query_param = {}
      response = @dh.get_post_by_id(post_id, query_param)

      process_post(response.body)

    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end

  end

  # GET /posts/new
  def new
    #@post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    #@post = Post.new(post_params)
#
    #if @post.save
    #  redirect_to @post, notice: 'Post was successfully created.'
    #else
    #  render :new
    #end
  end

  # PATCH/PUT /posts/1
  def update
    #if @post.update(post_params)
    #  redirect_to @post, notice: 'Post was successfully updated.'
    #else
    #  render :edit
    #end
  end

  # DELETE /posts/1
  def destroy
    #@post.destroy
    #redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end


  def get_post_by_slug

    begin

      slug = params[:article]
      Rails.logger.debug "Post slug is #{slug}\n"

      query_param = {filter: {name: slug}}
    
      response = @dh.get_post_by_slug(query_param)

      #Rails.logger.debug "\n\n\nDisplaying post(s) ....\n"
      #@dh.display_posts(response.body)
  
      process_post(response.body)

    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end
    
    
  end

  def get_posts_by_category

    begin

      category = params[:category]
      Rails.logger.debug "Post category is #{category}\n"

      query_param = {filter: {category_name: category}}
    
      response = @dh.get_post_by_slug(query_param)

      #Rails.logger.debug "\n\n\nDisplaying post(s) ....\n"
      #@dh.display_posts(response.body)
  
      process_post(response.body)

    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end

    begin
      query_params = {page: params[:page] || 1, per_page: params[:per_page] || 10}

      category = params[:category]
      Rails.logger.debug "Post category is #{category}\n"

      query_param = {filter: {category_name: category}}
    
      response = @dh.get_post_by_slug(query_param)

      @posts = JSON.parse(response.body)
      @total_posts, @total_pages = @dh.get_pagination_params(response.headers)
      @paginatable_array = Kaminari.paginate_array((1..@total_posts.to_i).to_a).page(params[:page] || 1).per(10)
    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end
    
  end







  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      #@post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params[:post]
    end

    def set_dream_host_instance
      @dh = DHHtp.new(DHHtp::HOST_IP)
    end

    # user can access the post only if he/she had signed in
    def verify_post_access(cat)

      post_id = params[:id]
      Rails.logger.debug "In verify_post_access(). Post id is #{post_id}\n"

      if article_for_member_only?(cat)

        return user_signed_in?
      else
        # the article is not for member only, so let them see it
        return true
      end

    end


    def process_post(response)

      # convert JSON string to hash
      post = JSON.parse(response)

      #Rails.logger.debug "Post is: #{post.inspect}\n\n"

      # determine if post is an array post or a single post
      if ( post.is_a?(Array))

        # retrieve the first post from the array
        post = post[0]

        Rails.logger.debug "\nUsing first element in the post array. "
      end

      @post_content = post['content']['rendered']
      
      @title = post['title']['rendered']

      @subtitle = !post['wps_subtitle'].empty? ? post['wps_subtitle'] : post['td_post_theme_settings']['td_subtitle']

      @excerpt = post['excerpt']['rendered']
     
      @post_date = post['date']
     
      @author = post['author_meta']['display_name']
      
      @categories = post['categories']
      Rails.logger.debug "categories id are #{@categories.inspect}\n"

      # determine whether the post has a feature image. If not, use the default image
      @feature_img = post['md_thumbnail'] =~ /^http/ ? post['md_thumbnail'] : 'default_feature_img.jpg'
  
  
      respond_to do |format|

        # init paywall url
        session[:paywall_url] = nil
  
        if verify_post_access(@categories)
          # user sign in and is authorize to see the post
          format.html { render template: "posts/show" }
        else
          # Copied from pages_controller
          # user goes back from wizard form to blog page
          if params.has_key?(:profile_id) && @profile = Profile.find(params[:profile_id])
            @response = {form: 'profiles/name_and_email', method: :put}
          else
            @profile = Profile.new
            @response = {form: 'profiles/name_and_email', method: :post}
          end

          Rails.logger.debug "request.fullpath is #{request.fullpath.inspect}\n"

          # store the paywall url so user can be redirected back to this URL after signing in
          session[:paywall_url] = request.fullpath

          format.html { render template: "posts/show-restrict" }
        end
          
      end
      
    end

    

end
