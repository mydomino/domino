class UserPreview < ActionMailer::Preview
	def welcome
    email = "foo@bar.com"
		UserMailer.welcome_email(email)
	end
end
