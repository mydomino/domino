class NotifierPreview < ActionMailer::Preview
  def welcome
    UserMailer.welcome_email('foo@bar.com')
  end

  def welcome_universal
    UserMailer.welcome_email_universal('foo@bar.com')
  end

  def email_template
    UserMailer.email_template('foo@bar.com')
  end
end