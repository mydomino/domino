class GetStartedsController < ApplicationController
  
  def step_1
    
  end

  def step_2
    @get_started = GetStarted.new
  end

  def step_3
    @get_started = GetStarted.new
  end

end