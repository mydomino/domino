class ErrorsController < ApplicationController
  def not_found
    Rails.logger.info "404 error is caught here"
    render(:status => 404)
  end

  def internal_server_error
    Rails.logger.info "internal_server_error is caught here"
    render(:status => 500)
  end

  def user_error
    process_error_mesg

  end

  def application_error
    process_error_mesg
  end



  private

    def process_error_mesg
    	Rails.logger.info " Error Message is #{params[:err_mesg]}\n"
    	@err_mesg = params[:err_mesg].nil? ? '' : params[:err_mesg]
    end
end
