class RegistrationsController < Devise::RegistrationsController

  protected

    def after_update_path_for(resource)
      edit_concierge_path
    end

end