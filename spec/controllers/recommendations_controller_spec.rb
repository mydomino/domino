require 'rails_helper'
require 'recommendations_controller'

RSpec.describe RecommendationsController, type: :controller do

  let(:product) { FactoryGirl.create(:product) }
  let(:recommendation) { FactoryGirl.create(:recommendation, recommendable: product) }
  let(:concierge) { FactoryGirl.create(:concierge) } 

  it 'renders complete properly' do
    sign_in concierge

    post :complete, recommendation_id: recommendation.id

    expect(response).to have_http_status(:found)
    recommendation.reload
    expect(recommendation.done).to be true
    expect(recommendation.updated_by).to eq(concierge.id)
  end

  it 'can undo a completion' do
    sign_in concierge

    post :complete, recommendation_id: recommendation.id
    recommendation.reload
    expect(recommendation.done).to be true

    post :undo, recommendation_id: recommendation.id

    expect(response).to have_http_status(302)
    recommendation.reload
    expect(recommendation.done).to be false
    expect(recommendation.updated_by).to eq(concierge.id)
  end

end