require 'rails_helper'
require 'pages_controller'

describe PagesController do
  it 'displays the home page' do
    get :index

    expect(response).to render('index')
  end
  it 'displays the about page'
  it 'displays the terms page'
end