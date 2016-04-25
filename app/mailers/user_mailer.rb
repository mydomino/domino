class UserMailer < ActionMailer::Base
  def welcome_email(email)
    @profile = Profile.find_by_email(email)
    mail(from: '"Amy Gorman" <amy@mydomino.com>', to: email, subject: 'Welcome to MyDomino!')
  end

  def legacy_user_registration_email(email)
    # @profile = Profile.find_by_email(email)
    @email = email
    mail(from: '"Amy Gorman" <amy@mydomino.com>', to: @email, subject: 'Announcing a new look and login for MyDomino!')
  end
end