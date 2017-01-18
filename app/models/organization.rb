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
#

class Organization < ActiveRecord::Base
	has_many :teams, dependent: :destroy
	has_many :users, dependent: :nullify
	has_many :subscriptions, dependent: :destroy

	validates :name, :presence => true

	LOGO_FULL_FILE_PATH = "#{Rails.root}/app/assets/images/partner_logos"
	LOGO_ASSETS_FILE_PATH = "partner_logos"




	def has_logo?

      puts "logo_fullpath_filename is #{logo_fullpath_filename}\n"
      return File.exists? logo_fullpath_filename
      
    end

    # return the Rails's assets pipeline path and file name of the organization logo
    def logo_path_name
      
      a = File.join LOGO_ASSETS_FILE_PATH, "#{self.name.downcase}_logo_400X400.png"
      puts "logo_path_name is #{a}\n"
      File.join LOGO_ASSETS_FILE_PATH, "#{self.name.downcase}_logo_400X400.png"
    end

    # return the full path and file name of the organization logo
	def logo_fullpath_filename

      File.join LOGO_FULL_FILE_PATH, "#{self.name.downcase}_logo_400X400.png"
    end


    #########################################################################
    private
	

	
end
