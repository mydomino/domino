class RegistrationsController < Devise::RegistrationsController
  # layout 'concierge'
  
  def new
    @email = params[:email]
    super
  end

  def after_sign_up_path_for(resource)
    '/' # Or :prefix_to_your_route
  end
  
  protected

    def after_update_path_for(resource)
      edit_concierge_path
    end

end