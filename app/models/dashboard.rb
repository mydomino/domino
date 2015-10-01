class Dashboard < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  has_many :recommendations
  has_many :products, through: :recommendations, source: :recommendable, source_type: :Product
  has_many :tasks, through: :recommendations, source: :recommendable, source_type: :Task
  belongs_to :concierge
  validates :lead_email, presence: true

  def slug_candidates
    #OK, there has to be a better way to do this but I don't know it : (
    [
      :lead_name,
      [:lead_name, '1'],
      [:lead_name, '2'],
      [:lead_name, '3'],
      [:lead_name, '4'],
      [:lead_name, '5'],
      [:lead_name, '6'],
      [:lead_name, '7'],
      [:lead_name, '8'],
      [:lead_name, '9']
    ]
  end

end