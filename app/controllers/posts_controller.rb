require 'dh_htp_wp_rest_api'   #find this in lib folder

class PostsController < ApplicationController
  #before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_dream_host_instance

  HOST_IP = 'mydomino.dreamhosters.com'

  # GET /posts
  def index

    begin

      #query_param = {filter: {orderby: 'rand', posts_per_page: 8}}
      query_param = {filter: {posts_per_page: 6}}
      
      response = @dh.get_posts(query_param)
  
      #Rails.logger.info "\nResponse is: #{response}\n"
      #dh.display_posts(response)

      # convert JSON string to hash
      @posts = JSON.parse(response.body)
      
  
    rescue => e
      Rails.logger.info "\nError! #{e}\n"        
    end

  end

  # GET /posts/1
  def show
 
    post_id = params[:id]
    Rails.logger.debug "Post id is #{post_id}\n"

    #@post_content = params[:post_content]
    query_param = {}
    response = @dh.get_post_by_id(post_id, query_param)

    # convert JSON string to hash
    post = JSON.parse(response.body)
    @post_content = post['content']['rendered']

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
      @dh = DHHtp.new(HOST_IP)
    end
end
