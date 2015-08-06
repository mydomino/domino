require 'rails_helper'
require 'leads_controller'

describe LeadsController do
  it 'adds browser info to session' do
    post :create, :lead => {"email" => Faker::Internet.email}

    expect(session[:browser]).to eq('Rails Testing')
  end
end