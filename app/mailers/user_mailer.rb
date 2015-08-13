class UserMailer < ActionMailer::Base
  def welcome_email(email)
    mail(from: '"Amy Gorman" amy@mydomino.com', to: email, subject: 'Thanks From Domino')
  end
end