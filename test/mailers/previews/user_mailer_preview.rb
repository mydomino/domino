class UserPreview < ActionMailer::Preview
	def welcome
    email = "foo@bar.com"
		UserMailer.welcome_email(email)
	end

  def welcome_test
    @profile = Profile.new(first_name: 'Foo', last_name: 'Bar', email: "foobar@mydomino.com")
    UserMailer.welcome_email_test(@profile.email)
  end
end
