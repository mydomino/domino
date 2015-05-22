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
      redirect_to snippets_url
    else
      render :new
    end
  end

  def update
    @snippet.update(snippet_params)
    redirect_to snippets_url
  end

  def destroy
    @snippet.destroy
    redirect_to snippets_url
  end

  private

  def snippet_params
    params.require(:snippet).permit(:name, :content, :parent_id)
  end

  def find_snippet
    @snippet = Snippet.find(params[:id])
  end
end
