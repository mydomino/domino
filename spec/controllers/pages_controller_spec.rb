require 'rails_helper'
require 'pages_controller'

describe PagesController do
  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @profile" do
      profile = Profile.new
      get :index
      expect(assigns(:profile)).to be_kind_of(Profile)
    end
  end

  describe "GET terms" do
    it "renders the terms template" do
      get :terms
      expect(response).to render_template(:terms)
    end
  end
end

  # it 'displays the terms page' do
  #   get :terms
  #   expect(response).to render_template(:terms)
  # end
# end