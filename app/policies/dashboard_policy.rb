class DashboardPolicy < ApplicationPolicy
  def index?
    user.role == 'concierge'
  end

  def show?
    (record.user_id == user.id) || (user.role == 'concierge')
  end
end