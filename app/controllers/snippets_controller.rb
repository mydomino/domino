class SnippetsController < ApplicationController
  before_filter :find_snippet, :only => [:show, :update, :destroy]

  def index
    @snippets = Snippet.all
    @snippet = Snippet.new
  end

  def show
  end

  def new
    @snippet = Snippet.new(parent_id: params[:parent_id])
    render :show
  end

  def create
    @snippet = Snippet.new(snippet_params)
    if @snippet.save
      expire_cache
      redirect_to snippets_url
    else
      render :new
    end
  end

  def update
    @snippet.update(snippet_params)
    # TODO: Should change this to a publisher-subscriber or similar pattern
    expire_cache
    redirect_to snippets_url
  end

  def destroy
    @snippet.destroy
    expire_cache
    redirect_to snippets_url
  end

  def import
    Snippet.destroy_all
    Snippet.import(import_params[:file].tempfile.read)
    expire_cache
    redirect_to snippets_url
  end

  def export
    send_data Snippet.export,
              {filename: "snippet_export_#{Time.now.to_s(:number)}.json"}
  end

  private

  def snippet_params
    params.require(:snippet).permit(:name, :content, :parent_id)
  end

  def import_params
    params.permit(:file)
  end

  def find_snippet
    @snippet = Snippet.find(params[:id])
  end

  def expire_cache
    expire_page controller: :sessions, action: [:index, :about, :getstarted]
  end
end
