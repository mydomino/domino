require 'rails_helper'
require 'dashboards_controller'

describe DashboardsController do
  describe "anonymous user" do
    before :each do
      # This simulates an anonymous user
      login_with nil
    end

    it "should be redirected to signin" do
      get :show
      expect( response ).to redirect_to( new_user_session_path )
    end

    it "should let a user see their dashboard" do
      dashboard = create ( :dashboard )
      login_with dashboard.user
      get :show
      expect( response ).to render_template( :show )
    end

    it "should let a concierge user see all dashboards" do
      concierge = create ( :concierge )
      login_with concierge
      get :index
      expect( response ).to render_template( :index )
    end
  end
end
