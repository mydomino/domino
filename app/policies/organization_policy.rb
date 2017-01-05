class OrganizationPolicy < ApplicationPolicy

	def index?
    user.role == 'concierge'
  end

  def create?
    user.role == 'concierge'
  end

  def new?
    user.role == 'concierge'
  end

  def add_individual?
  	Rails.logger.debug  'org policy add_individual is called.'
    (user.role == 'concierge') || (user.role == 'org_admin')
  end

  def update?
    Rails.logger.debug  'org policy update is called.'
    (user.role == 'concierge') || (user.role == 'org_admin')
  end

  def edit?
    Rails.logger.debug  'org policy edit is called.'
    (user.role == 'concierge') || (user.role == 'org_admin')
  end

  def destroy?
    user.role == 'concierge'
  end

  def show?
  	Rails.logger.debug  'org policy show is called.'
    (user.role == 'concierge') || (user.role == 'org_admin')
  end



end