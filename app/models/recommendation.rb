class Recommendation < ActiveRecord::Base
  
  belongs_to :dashboard
  belongs_to :recommendable, polymorphic: true
  belongs_to :concierge

  validates :recommendable_id, uniqueness: {scope: [:dashboard_id, :recommendable_type] }
  validates :dashboard_id, presence: true

  default_scope { order("done ASC") }
  scope :tasks, -> { where(recommendable_type: 'Task') }
  scope :products, -> { where(recommendable_type: 'Product') }
  scope :done, -> { where(done: true) }
  scope :timestamped, -> { where("created_at IS NOT NULL AND updated_at IS NOT NULL")}

  after_create :assign_concierge, :set_done_to_false

  def assign_concierge
    self.update_attribute(:concierge_id, dashboard.concierge_id)
  end

  def set_done_to_false
    self.update_attribute(:done, false)
  end

  def global_recommendable
    self.recommendable.to_global_id if self.recommendable.present?
  end

  def gid_string
    global_recommendable.to_s
  end

  def global_recommendable=(recommendable_gid)
    self.recommendable = GlobalID::Locator.locate recommendable_gid
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << ["User Name", "User Email", "Recommendation Name", "Recommendation Type", "Date Marked Done", "Concierge"]
      done.includes(:dashboard, :recommendable, :concierge).each do |rec|
        csv << [rec.dashboard.lead_name, rec.dashboard.lead_email, rec.recommendable.name, rec.recommendable_type, rec.updated_at, rec.concierge.email]
      end
    end
  end

end