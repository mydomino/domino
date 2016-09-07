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

  describe "GET about" do
    it "renders the about template" do
      get :about
      expect(response).to render_template(:about)
    end
  end
  
  describe "GET terms" do
    it "renders the terms template" do
      get :terms
      expect(response).to render_template(:terms)
    end
  end

  describe "GET team" do
    it "renders the team template" do
      get :team
      expect(response).to render_template(:team)
    end
  end

  describe "GET privacy" do
    it "renders the privacy template" do
      get :privacy
      expect(response).to render_template(:privacy)
    end
  end

  describe "GET faq" do
    it "renders the faq template" do
      get :faq
      expect(response).to render_template(:faq)
    end
  end

end
