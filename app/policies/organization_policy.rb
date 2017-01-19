class OrganizationPolicy < ApplicationPolicy

  def add_individual?
    (user.role == 'concierge') || (user.role == 'org_admin' && record.id == user.organization.id )
  end

  def show?
    (user.role == 'concierge') || (user.role == 'org_admin' && record.id == user.organization.id)
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

end