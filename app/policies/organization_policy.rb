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

   def destroy?
    user.role == 'concierge'
  end

  def add_individual?
    (user.role == 'concierge') || (user.role == 'org_admin' )
  end

  def update?
    (user.role == 'concierge') || (user.role == 'org_admin')
  end

  def edit?
    (user.role == 'concierge') || (user.role == 'org_admin')
  end

  def show?
    (user.role == 'concierge') || (user.role == 'org_admin')
  end


  def email_members_upload_file?
    (user.role == 'concierge') || (user.role == 'org_admin')
  end

  def import_members_upload_file?
    (user.role == 'concierge') || (user.role == 'org_admin')
  end

  def download_csv_template?
    (user.role == 'concierge') || (user.role == 'org_admin')
  end

  def test?
    (user.role == 'concierge') || (user.role == 'org_admin')
  end

end