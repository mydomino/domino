class UserMailer < ActionMailer::Base
  def welcome_email(email)
    @profile = Profile.find_by_email(email)
    mail(from: 'MyDomino <team@mydomino.com>', to: email, subject: 'Welcome to MyDomino!')
  end

  def welcome_email_universal(email)
    @host = UserMailer.default_url_options[:host]
    @profile = Profile.find_by_email(email)
    mail(from: 'MyDomino <team@mydomino.com>', to: email, subject: 'Welcome to MyDomino!' ) #if !user.opted_out?
  end

  def legacy_user_registration_email(email)
    @email = email
    mail(from: 'MyDomino <team@mydomino.com>', to: @email, subject: 'Announcing a new look and login for MyDomino!')
  end

  def legacy_user_registration_email_universal(email)
    @email = email
    @host = UserMailer.default_url_options[:host]
    mail(from: 'MyDomino <team@mydomino.com>', to: @email, subject: 'Announcing a new look and login for MyDomino!')
  end

  def email_template(email)
    mail(from: 'MyDomino <team@mydomino.com>', to: email, subject: 'This is the MyDomino email template' ) #if !user.opted_out?
  end
end