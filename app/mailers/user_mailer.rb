class UserMailer < ActionMailer::Base
  def welcome_email(email)
    @profile = Profile.find_by_email(email)
    mail(from: 'MyDomino Team <team@mydomino.com>', to: email, subject: 'Welcome to MyDomino!')
  end

  def welcome_email_universal(email)
    mail(from: '"MyDomino Team" <team@mydomino.com>', to: email, subject: 'This is the MyDomino email template' ) #if !user.opted_out?
  end

  def legacy_user_registration_email(email)
    # @profile = Profile.find_by_email(email)
    @email = email
    mail(from: '"MyDomino Team" <team@mydomino.com>', to: @email, subject: 'Announcing a new look and login for MyDomino!')
  end

  def email_template(email)
    # user = User.find_by_email(email)
    mail(from: '"MyDomino Team" <team@mydomino.com>', to: email, subject: 'This is the MyDomino email template' ) #if !user.opted_out?
  end
end