require 'rails_helper'
require 'recommendations_controller'
include Devise::TestHelpers

describe RecommendationsController do

  let(:product) { FactoryGirl.create(:product) }
  let(:recommendation) { FactoryGirl.create(:recommendation, recommendable: product) }

  it 'renders complete properly' do
    post :complete, recommendation_id: recommendation.id

    expect(response).to have_http_status(:found)
    recommendation.reload
    expect(recommendation.done).to be true
  end

  it 'can undo a completion' do
    post :complete, recommendation_id: recommendation.id
    recommendation.reload
    expect(recommendation.done).to be true

    post :undo, recommendation_id: recommendation.id

    expect(response).to have_http_status(302)
    recommendation.reload
    expect(recommendation.done).to be false
  end

end