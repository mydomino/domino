class AnalyticPolicy < ApplicationPolicy
  def show?
    user.role == 'concierge'
  end
end