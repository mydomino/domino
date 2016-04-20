class UserMailer < ActionMailer::Base
  def welcome_email_test(email)
    @profile = Profile.find_by_email(email)
    mail(from: '"Amy Gorman" <amy@mydomino.com>', to: email, subject: 'Thanks From Domino')
  end
  def welcome_email(email)
    @profile = Profile.find_by_email(email)
    mail(from: '"Amy Gorman" <amy@mydomino.com>', to: email, subject: 'Thanks From Domino')
  end

  def registration_email(email)
    @email = email
    mail(from: '"Amy Gorman" <amy@mydomino.com>', to: @email, subject: 'Get your Action Dashboard')
  end
end