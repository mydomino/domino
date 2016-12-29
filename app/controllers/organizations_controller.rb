class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /organizations/1
  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: 'Organization was successfully destroyed.'
  end

  def email_members_upload_file

    Rails.logger.debug "Action email_members_upload_file is called."

    # email the uploaded CSV file to mydomino
    UserMailer.email_csv_file(current_user, params[:file]).deliver_now
    
  end

  def import_members_upload_file
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find_by!(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def organization_params
      params.require(:organization).permit(:name, :email, :phone, :fax, :company_url, :sign_up_code, :join_date)
    end
end
