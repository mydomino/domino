require 'rails_helper'
require 'sessions_controller'

describe SessionsController do
  it 'adds browser info to session' do
    get :getstarted

    expect(session[:browser]).to eq('Rails Testing')
  end
end