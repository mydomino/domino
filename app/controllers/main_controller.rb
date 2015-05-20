class MainController < SessionsController
  def index
    @source = "main"
    super
  end
end
