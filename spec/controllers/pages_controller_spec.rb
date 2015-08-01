require 'rails_helper'
require 'pages_controller'

describe PagesController do
  it 'adds browser info to session' do
    get :index

    expect(session[:browser]).to eq('Rails Testing')
  end
end