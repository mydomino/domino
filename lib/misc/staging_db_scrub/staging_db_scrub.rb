path = "#{File.expand_path(File.dirname(__FILE__))}/email_scrub_list.csv"
emails = CSV.read(path, headers:true)
emails.each do |row|
  if @user = User.find_by_email(row['email'])
    @user.destroy
  elsif @profile = Profile.find_by_email(row['email'])
    @profile.destroy
  end
end