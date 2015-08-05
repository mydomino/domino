require 'rails_helper'
require 'pages_controller'

describe PagesController do
  it 'displays the home page' do
    get :index

    expect(response).to render_template(:index)
  end
  it 'displays the about page' do
    get :about

    expect(response).to render_template(:about)
  end
  it 'displays the terms page' do
    get :terms

    expect(response).to render_template(:terms)
  end
end