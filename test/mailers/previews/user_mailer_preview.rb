class UserPreview < ActionMailer::Preview
	def welcome
    @profile = Profile.create(first_name: 'Foo', last_name: 'Bar', email: "foobar@mydomino.com")
		UserMailer.welcome_email(@profile.email)
	end

  def legacy_user_registration

    @lu = LegacyUser.create(email: "foobar@mydomino.com")
    @db = Dashboard.create(lead_email: "foobar@mydomino.com" )
    UserMailer.legacy_user_registration_email(@lu.email)
  end

end
