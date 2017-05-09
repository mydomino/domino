class OrganizationsController < ApplicationController

  # Default password for individual members added via org admin dashboard
  DEFAULT_MEMBER_PASSWORD = 'ILoveCleanEnergy'

  before_action :set_organization, only: [:show, :add_individual, :email_members_upload_file, 
    :import_members_upload_file, :download_csv_template]

  before_action :authenticate_user!
  after_action :verify_authorized

  # GET /organizations/1
  def show
    authorize @organization
    
    # Empty user object for add indiviudal member form
    @user = User.new

    # Grab organization name to display on dashboard
    # Also, used for dynamically retrieving the company logo
    @organization_name = @organization.name

    # Grab email domain, to validate email domains client side
    # If no email domain exists, all domains are accepted when adding org members
    @organization_email_domain = @organization.email_domain
    if @organization_email_domain
      @email_regex = "[^]+@" + @organization_email_domain
    else
      @email_regex = "[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$"
    end
    
    # Member count is shown in the admin dashboard
    @member_count = @organization.users.size
  end

  # POST /organizations/1/add_individual
  # Purpose: Add member to organiztion via the org admin dashboard
  # Returns: JSON responses to client
  def add_individual
    authorize @organization

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

      # Send updated member count back to view
      member_count = @organization.users.size
      
      render json: {
          message: "Member added successfully",
          member_count: member_count, 
          status: 200
        }, status: 200
      else
        render json: {
          error: "Email already taken",
          status: 400
        }, status: 400
    end

  end

  def email_members_upload_file
    authorize Organization

    # check to make sure the CSV file was selected
    if params[:file].nil?
      redirect_to @organization, alert: 'Error! Please select a CSV file to upload.' and return
    end

    # email the uploaded CSV file to mydomino
    UserMailer.email_csv_file(current_user, params[:file]).deliver_now
    
  end

  def import_members_upload_file
    authorize Organization
  end

  def download_csv_template
    authorize Organization
    send_data generate_csv_template, filename: "#{@organization.name}_#{Date.today}.csv"
  end

  private

  def set_organization
    @organization = Organization.find_by!(id: params[:id])
  end

  def generate_csv_template
    CSV.generate do |csv|
      # Add new headers
      csv << ['First_name', 'Last_name', 'Email']
    end
  end

end
