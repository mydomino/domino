class UserPreview < ActionMailer::Preview
	def welcome
    email = "foo@bar.com"
		UserMailer.welcome_email(email)
	end

  def welcome_test
    UserMailer.welcome_email_test("foo@bar.com")
  end
end
