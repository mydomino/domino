class DashboardPolicy < ApplicationPolicy
  def index?
    user.role == 'concierge'
  end

  def show
    # user.admin? or not record.published?
    (record.user_id == user.id) || (user.role == 'concierge')
  end
end