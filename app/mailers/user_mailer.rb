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

  def email_csv_file(user, upload_file)

    @user = user
    csv_file_recipients = ENV['CSV_FILE_RECIPIENTS'].nil? ? %w(yong@mydomino.com johnp@mydomino.com marcian@mydomino.com) : ENV['CSV_FILE_RECIPIENTS'].split(',')
    org_name = @user.organization.nil? ? '' : @user.organization.name

    Rails.logger.info "Sending email with CSV file attachment to #{csv_file_recipients}....\n"

    attachments["#{upload_file.original_filename}"] = File.read(upload_file.path)
    mail(from: @user.email, to: csv_file_recipients, subject: "#{org_name} members CSV file upload")

    Rails.logger.info "Email with CSV file attachment was sent.\n"
    
  end
  
end