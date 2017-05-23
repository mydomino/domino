# == Schema Information
#
# Table name: organizations
#
#  id           :integer          not null, primary key
#  name         :string
#  email        :string
#  phone        :string
#  fax          :string
#  company_url  :string
#  sign_up_code :string
#  join_date    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  users_count  :integer          default(0)
#  email_domain :string
#










class Organization < ActiveRecord::Base
	has_many :teams, dependent: :destroy
	has_many :users, dependent: :nullify
	has_many :subscriptions, dependent: :destroy

	validates :name, :email, :presence => true

  # equivalent to this but more portable between OS "#{Rails.root}/public/images/organization_logos"
	#LOGO_FULL_FILE_PATH = File.join "#{Rails.root}", "app", "assets", "images", "organization_logos" 
  LOGO_FULL_FILE_PATH = File.join "#{Rails.root}", "public", "images", "organization_logos" 
	LOGO_ASSETS_FILE_PATH = "organization_logos"



  #################################################################
  # 
  # Note about placing image files in Rails
  # If Rails can find the image in the asset folders, then it will link to the compiled asset path. 
  # If it can not find the image, it will link to the images folder under public instead
  # 
  # image_tag("logo.png") 
  # => '/assets/logo-f2c87c4e3fda671a619ccb7...png'  # if image exists
  # => '/images/logo.png'   # if image does not exists in asset folder


	def has_logo?

    return File.exists? logo_fullpath_filename
    
  end

  # return the Rails's assets pipeline path and file name of the organization logo
  def logo_path_name
    
    File.join LOGO_ASSETS_FILE_PATH, "#{self.name.downcase}_logo_400X400.png"

    # hmmm.... This does not work for image_tag
    #File.join "organization_logos", "#{self.name.downcase}_logo_400X400.png"

    #"organization_logos/#{self.name.downcase}_logo_400x400.png"

  end

  # return the full path and file name of the organization logo
	def logo_fullpath_filename

    File.join LOGO_FULL_FILE_PATH, "#{self.name.downcase}_logo_400X400.png"
  end

  # /get_leaderboard
  # Purpose: returns the organization's leaderboard
  def get_leaderboard
    users = self.users
    users.each do |u|
      u.point_log.get_points
    end
  end

  #########################################################################
  private
	

	
end
