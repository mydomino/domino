require 'rails_helper'
require 'analytics_controller'

describe AnalyticsController, focus: true do
  
  describe "GET show" do
    it 'redirects if user is not a concierge' do
      get :show
      # expect(response).to eq(403)
    end
  end

end