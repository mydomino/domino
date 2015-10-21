class GetStartedsController < ApplicationController
  
  def step_1
    
  end

  def step_2
    #this isn't actually what we're going to do in the real version but
    #it's ok for right now
    @get_started = GetStarted.new
  end

  def step_3
    @get_started = GetStarted.new
  end

end