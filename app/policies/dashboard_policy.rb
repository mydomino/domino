class DashboardPolicy < ApplicationPolicy
  def index
    user.role == 'concierge'
  def show
    # user.admin? or not record.published?
    record.user_id == user.id
  end
end