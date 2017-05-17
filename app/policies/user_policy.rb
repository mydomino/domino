class UserPolicy < ApplicationPolicy
  def beta_index?
    /mydomino.com/.match(user.email)
  end
end