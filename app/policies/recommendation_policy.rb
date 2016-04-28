class RecommendationPolicy < ApplicationPolicy
  def create?
    user.role == 'concierge'
  end

  def new?
    user.role == 'concierge'
  end

  def index?
    user.role == 'concierge'
  end

  def update?
    user.role == 'concierge'
  end
end
