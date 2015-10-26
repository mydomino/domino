require 'rails_helper'
require 'get_starteds_controller'


describe GetStartedsController do

  it 'stores the get_started in the session after POSTing to any step', focus: true do
    get :step_2
    
    expect(session[:get_started_id]).not_to be_nil
  end

end