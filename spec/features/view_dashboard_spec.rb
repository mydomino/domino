require 'rails_helper'

feature "View dashboard" do

  scenario "and see tasks and products" do
    dashboard = set_up_dashboard
    recommendations = add_recommendations dashboard
    expect(dashboard).not_to eq(nil)
    visit(dashboard_path(dashboard))

    expect_page_to_have_recommendations(recommendations)
  end

  def add_recommendations dashboard
    recommendations = []
    recommendations << add_completed_product(dashboard)
    recommendations << add_incomplete_product(dashboard)
    recommendations << add_completed_task(dashboard)
    recommendations << add_incomplete_task(dashboard)
    recommendations
  end

  def set_up_dashboard
    dashboard = FactoryGirl.create(:dashboard)
  end

  def add_completed_product dashboard
    product = FactoryGirl.create(:product)
    dashboard.products << product
    Recommendation.find_by(recommendable_id: product.id, 
                           recommendable_type: "Product").update_attribute(:done, 
                                                                          true)
    product
  end

  def add_incomplete_product dashboard
    product = FactoryGirl.create(:product)
    dashboard.products << product
    product
  end

  def expect_page_to_have_recommendations recommendations
    recommendations.each do |rec|
      expect(page).to have_content(rec.name)
    end
  end

  def add_completed_task dashboard
    task = FactoryGirl.create(:task)
    dashboard.tasks << task
    Recommendation.find_by(recommendable_id: task.id,
                           recommendable_type: "Task").update_attribute(:done, 
                                                                        true)
    task
  end

  def add_incomplete_task dashboard
    task = FactoryGirl.create(:task)
    dashboard.tasks << task
    task
  end
end
