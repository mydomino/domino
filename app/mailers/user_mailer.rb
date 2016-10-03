class UserMailer < ActionMailer::Base

  def welcome_email_universal(email)
    @host = UserMailer.default_url_options[:host]
    @profile = Profile.find_by_email(email)
    mail(from: 'MyDomino <team@mydomino.com>', to: email, subject: 'Welcome to MyDomino!' ) #if !user.opted_out?
  end

  def email_template(email)
    mail(from: 'MyDomino <team@mydomino.com>', to: email, subject: 'This is the MyDomino email template' ) #if !user.opted_out?
  end

  def onboard_started(profile)
    @profile = profile
    mail(from: 'MyDomino <dev@mydomino.com>', to: 'stephen@mydomino.com', subject: "Onboard started: #{@profile.first_name.capitalize} #{@profile.last_name.capitalize}")
  end
  
end