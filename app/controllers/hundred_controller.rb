class HundredController < SessionsController
  def index
    @source = "hundred"
    super
  end
end