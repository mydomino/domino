require 'dh_htp_wp_rest_api'   #find this in lib folder
require 'wp_relation' 

class PostsController < ApplicationController
  #before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_dream_host_instance
  #before_filter :verify_post_access

  #HOST_IP = 'mydomino.dreamhosters.com'

  # GET /posts
  

  def index

    @total_posts, @total_pages = 0
    @posts = []

    begin

      #query_param = {filter: {orderby: 'rand', posts_per_page: 8}}
      query_param = {page: params[:page] || 1, per_page: params[:per_page] || 10}
      
      response = @dh.get_posts(query_param)
  
      #Rails.logger.info "\nResponse is: #{response}\n"
      #@dh.display_posts(response)

      # convert JSON string to hash
      @posts = JSON.parse(response.body)

      @total_posts, @total_pages = @dh.get_pagination_params(response.headers)


      #@posts = WPRelation.new(params[:page] || 1, params[:per_page] || 8)
      
  
    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end

  end

  # GET /posts/1
  def show

    @post_content, @title, @excerpt, @post_date, @author = ""
 
    begin

      post_id = params[:id]
      #Rails.logger.debug "Post id is #{post_id}\n"

      #categories = params[:cat]
      #Rails.logger.debug "categories param is #{categories.inspect}\n"
  
      #@post_content = params[:post_content]
      query_param = {}
      response = @dh.get_post_by_id(post_id, query_param)
  
      # convert JSON string to hash
      post = JSON.parse(response.body)
      @post_content = post['content']['rendered']
      @title = post['title']['rendered']
      @excerpt = post['excerpt']['rendered']
      @post_date = post['date']
      @author = post['author_meta']['display_name']
      @categories = post['categories']

      Rails.logger.debug "categories id are #{@categories.inspect}\n"

      # determine whether the post has a feature image. If not, use the default image
      @feature_img = post['md_thumbnail'] =~ /^http/ ? post['md_thumbnail'] : 'default_feature_img.jpg'
  
  
      respond_to do |format|
  
        if verify_post_access(@categories)
          # user sign in and is authorize to see the post
          format.html { render template: "posts/show" }
        else
          format.html { render template: "posts/show-restrict" }
        end
          
      end

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

    

end
