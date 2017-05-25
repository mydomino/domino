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

  #def email_user_with_on_board_url(org_name, u_fn, u_ln, u_email, signup_token)
  #  @org_name, @u_fn, @u_ln, @u_email, @signup_token = org_name, u_fn, u_ln, u_email, signup_token
#
  #  cc_recipients = ENV['CSV_FILE_RECIPIENTS'].nil? ? %w(yong@mydomino.com johnp@mydomino.com marcian@mydomino.com) : ENV['CSV_FILE_RECIPIENTS'].split(',')
#
  #  Rails.logger.info "Sending email with Onboard url to #{@u_email}....\n"
  #  mail(from: 'MyDomino <team@mydomino.com>', to: @u_email, subject: "Welcome to Mydomino. Here is your on-boarding instructions.", cc: cc_recipients)
#
  #end

  # /email_signup_link/
  # Purpose: Email user with a signup link
  #   The link will take users to their respective organization landing page
  #   where they may set a password
  # Arguments: User user
  def email_signup_link(user)
    @user = user
    @signup_link = @user.get_signup_link(root_url)

    mail(from: 'MyDomino <team@mydomino.com>', to: @user.email, subject: "Welcome to Mydomino. Here is your on-boarding instructions.")
  end

  
  # email a CSV file to MyDomino's staff
  def email_signup_link_csv_file(file_name, csv_str)
    csv_file_recipients = ENV['CSV_FILE_RECIPIENTS'].nil? ? %w(yong@mydomino.com johnp@mydomino.com marcian@mydomino.com) : ENV['CSV_FILE_RECIPIENTS'].split(',')
    attachments[file_name] = {mime_type: 'text/csv', content: csv_str}

    current_time_str = Time.now.in_time_zone("America/Los_Angeles").strftime('%Y-%m-%d_%H%M')
    mail(from: "dev@mydomino.com", to: csv_file_recipients, subject: "CSV of newly added members on #{current_time_str}")
    Rails.logger.info "Signup Link Function: Emailing CSV file attachment to #{csv_file_recipients}....\n"
  end

  def email_notification(user, notification)
    @notification = notification
    @user = user
    mail(from: "dev@mydomino.com", to: @user.email, subject: "A friendly food action tracking reminder for you to take action")
  end
  
  private

  # /org_member_sign_up/
  # Purpose: Returns an org member sign up link.
  # ex: https://www.mydomino.com/sungevity?email=foo%40sungevity.com&a=vefwzr6tdy3-JD-6fFtM-A
  # def org_member_signup_link(user)
  #   org_name = user.organization.name.downcase
  #   email = user.email
  #   token = user.signup_token
  #   "#{root_url}#{org_name}?a=#{token}"
  # end

  # /org_member_sign_up/
  # Purpose: Returns an org member sign up link.
  # ex: https://www.mydomino.com/sungevity?email=foo%40sungevity.com&a=vefwzr6tdy3-JD-6fFtM-A
  # def non_org_member_signup_link(user)
  #   email = user.email
  #   token = user.signup_token
  #   "#{root_url}pm?email=#{email}&a=#{token}"
  # end
end
