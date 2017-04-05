require 'dh_htp_wp_rest_api'

class PostsController < ApplicationController
  include PostsHelper
  
  before_action :set_dream_host_instance

  # GET /posts
  def index
    query_params = {page: params[:page] || 1, per_page: params[:per_page] || 10}

    #add a category if it is specified in the query
    if !params[:cat].nil?
      category_id = PostsHelper::CATEGORY_SLUG_TO_ID[params[:cat]]
      if category_id
        query_params.merge!({categories: category_id})
      end
    end
    response = @dh.get_posts(query_params)

    @posts = JSON.parse(response.body)
    @total_posts, @total_pages = @dh.get_pagination_params(response.headers)
    @paginatable_array = Kaminari.paginate_array((1..@total_posts.to_i).to_a).page(params[:page] || 1).per(10)

    track_event "Article index page view"
  end

  # GET /posts/1
  def show
    post_id = params[:id]
    query_param = {}

    response = @dh.get_post_by_id(post_id, query_param)

    process_post(response.body)

    track_event "Article pageview", {"article_id": post_id.to_s}
  end

  def get_post_by_slug
    slug = params[:article]

    query_param = {slug: slug}

    response = @dh.get_post_by_slug(query_param)

    process_post(response.body)

    track_event "Article page view", {"Article_slug": slug}
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

    # determine if post is an array post or a single post
    if ( post.is_a?(Array))

      # retrieve the first post from the array
      post = post[0]

    end

    @post_content = post['content']['rendered']
    
    @title = post['title']['rendered']

    @subtitle = !post['wps_subtitle'].empty? ? post['wps_subtitle'] : post['td_post_theme_settings']['td_subtitle']

    @excerpt = post['excerpt']['rendered']
   
    @post_date = post['date']
   
    @author = post['author_meta']['display_name']
    
    @categories = post['categories']

    # determine whether the post has a feature image. If not, use the default image
    @feature_img = post['md_thumbnail'] =~ /^http/ ? post['md_thumbnail'] : 'default_feature_img.jpg'

    @article_slug = post['slug']
    @post_id = post['id']

    # Set open graph meta variables for sharing articles on facebook
    @post_og_meta = {
      url: "#{request.original_url}",
      title: @title,
      description: @excerpt,
      image: @feature_img
    }

    respond_to do |format|
      if verify_post_access(@categories)
        # user sign in and is authorize to see the post
        format.html { render template: "posts/show" }
      else
        @profile = Profile.new
        @response = {form: 'profiles/name_and_email', method: :post}

        format.html { render template: "posts/show-restrict" }
      end
    end
  end
end
