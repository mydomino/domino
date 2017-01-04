class OrganizationsController < ApplicationController

  # Default password for individual members added via org admin dashboard
  DEFAULT_MEMBER_PASSWORD = 'ILoveCleanEnergy'

  before_action :set_organization, only: [:show, :edit, :update, :destroy, :add_individual, :email_members_upload_file, 
    :import_members_upload_file, :test, :download_csv_template]

  # GET /organizations
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1
  def show
    @user = User.new # Empty user object for add indiviudal member form
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

  # POST /organizations/1/add_individual
  def add_individual
    # Form params
    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:user][:email]

    # Create user record
    # Record is assigned the default pw
    # Record is associated with the organization
    @user = User.new(
      email: email,
      password: DEFAULT_MEMBER_PASSWORD,
      password_confirmation: DEFAULT_MEMBER_PASSWORD,
      organization: @organization
    )
    
    # If user record is valid (i.e record with provided email doesn't exist),
    # Provision Profile and Dashboard resources.
    if @user.save
      # Provision Dashboard
      @dashboard = Dashboard.create(
        lead_name: "#{first_name} #{last_name}", 
        lead_email: @user.email
      )

      @user.dashboard = @dashboard

      #Provision Profile
      @profile = Profile.create(
        first_name: first_name, 
        last_name: last_name, 
        email: @user.email, 
        user: @user
      )
      
      redirect_to @organization
    else
      render :show
    end
  end

  def email_members_upload_file

    Rails.logger.debug "Action email_members_upload_file is called."

    # check to make sure the CSV file was selected
    if params[:file].nil?
      redirect_to @organization, alert: 'Error! Please select a CSV file for upload.' and return
    end

    # email the uploaded CSV file to mydomino
    UserMailer.email_csv_file(current_user, params[:file]).deliver_now
    
  end

  def import_members_upload_file
    
  end

  def test
  end

  def download_csv_template

    send_data generate_csv_template, filename: "#{@organization.name}_#{Date.today}.csv"

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

    def generate_csv_template

      CSV.generate do |csv|
        # Add new headers
        csv << ['First_name', 'Last_name', 'Email']
      end
    end

end
