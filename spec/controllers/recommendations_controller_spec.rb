require 'rails_helper'
require 'recommendations_controller'
include Devise::TestHelpers

describe RecommendationsController do

  let(:recommendation) { FactoryGirl.create(:recommendation) }

  it 'renders complete properly' do
    post :complete, recommendation_id: recommendation.id

    expect(response).to have_http_status(:found)
    recommendation.reload
    expect(recommendation.done).to be true
  end

end