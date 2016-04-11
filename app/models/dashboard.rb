class Dashboard < ActiveRecord::Base
  # extend FriendlyId
  # friendly_id :slug_candidates, use: :slugged
  has_many :recommendations, dependent: :destroy
  has_many :products, through: :recommendations, source: :recommendable, source_type: :Product
  has_many :tasks, through: :recommendations, source: :recommendable, source_type: :Task
  belongs_to :user

  #kaminari pagination
  # paginates_per 50
  # belongs_to :lead, foreign_key: :lead_email
  # validates :lead_email, presence: true


  # def slug_candidates(previous_attempts=nil)

  #   slug ||= self.lead_name.parameterize
    
  #   if(!previous_attempts)
  #     if(Dashboard.find_by_slug(slug))
  #       previous_attempts = 1  
  #     else
  #       return slug
  #     end
  #   end

  #   slug += "-#{previous_attempts}"

  #   if(Dashboard.find_by_slug(slug))
  #     previous_attempts += 1
  #     slug = slug_candidates(previous_attempts)
  #   end

  #   return slug
  # end
end