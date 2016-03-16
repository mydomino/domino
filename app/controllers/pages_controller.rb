class PagesController < ApplicationController
  caches_action :index, :about, :terms, :privacy, :solar

  def index
    @profile = Profile.new
  end

  def about

  end

  def terms

  end

  def privacy

  end

  def solar
    @lead = Lead.new
  end

end
