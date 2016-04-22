class UserPreview < ActionMailer::Preview
	def welcome
    @profile = Profile.create(first_name: 'Foo', last_name: 'Bar', email: "foobar@mydomino.com")
		UserMailer.welcome_email(@profile.email)
	end

  def legacy_user_registration
    @profile = Profile.create(first_name: 'Foo', last_name: 'Bar', email: "foobar@mydomino.com")
    UserMailer.legacy_user_registration_email(@profile.email)
  end

end
