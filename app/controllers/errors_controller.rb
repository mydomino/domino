class ErrorsController < ApplicationController
  def not_found
    render(:status => 404)
  end

  def internal_server_error
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
    	Rails.logger.debug " Error Message is #{params[:err_mesg]}\n"
    	@err_mesg = params[:err_mesg].nil? ? '' : params[:err_mesg]
    end
end
