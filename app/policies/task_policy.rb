class TaskPolicy < ApplicationPolicy
  def index?
    user.role == 'concierge'
  end
end