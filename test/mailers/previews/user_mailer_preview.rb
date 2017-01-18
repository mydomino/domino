class NotifierPreview < ActionMailer::Preview
  def welcome
    UserMailer.welcome_email('foo@bar.com')
  end

  def welcome_universal
    Profile.create(first_name: "Foo", last_name: "Bar", email: 'foo@bar.com')
    UserMailer.welcome_email_universal('foo@bar.com')
  end

  def legacy_universal
    UserMailer.legacy_user_registration_email_universal('foo@bar.com')
  end

  def legacy
    UserMailer.legacy_user_registration_email('foo@bar.com')
  end

  def email_template
    UserMailer.email_template('foo@bar.com')
  end

  def email_signup_link
    @user = User.last
    @user.organization = Organization.last
    UserMailer.email_signup_link @user
  end
end