class ConciergesController < ApplicationController
  before_action :authenticate_concierge!
  layout 'concierge'

  def edit
    @concierge = current_concierge
  end

  def update
    if current_concierge.update_attributes(concierge_params)
      redirect_to products_path
    else
      render :edit
    end
  end

  private

  def concierge_params
    params.require(:concierge).permit(:name)
  end

end