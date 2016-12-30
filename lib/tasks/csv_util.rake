namespace :csv do

	require 'faker'
	require 'csv'
	

	desc "Generate X number of fake data rows for CSV file upload. Example usage: rake csv:build_csv_file_with_fake_data 200"
  task build_csv_file_with_fake_data: :environment do 

  	DATA_SAVE_FOLDER = Rails.root.join('data')

  	# generate an empty task for each argument pass in
  	ARGV.each { |a| task a.to_sym do ; end }

  	# validate argument type - only number allow
  	if ARGV[1].nil? or ARGV[1] !~ /\A\d+\z/
  		puts "Error! Please include a number in your command. Example. rake csv:build_csv_file_with_fake_data 1000"
  		exit 1
  	end

  	# check to see if the data folder exist, if not create it
    full_path = File.expand_path("#{DATA_SAVE_FOLDER}")
    #puts "\nFull save path is: #{full_path}"

    if !File.exist?(full_path) 
      Dir.mkdir(full_path)
      puts "\nPath #{full_path} was created."
    end

    file_name_path = full_path + '/' + 'sample_upload_' + ARGV[1] + '.csv'
    puts "Data file is saved on #{file_name_path}."

  	CSV.open(file_name_path, 'w') do |csv| 

      # Add new headers
      csv << ['First_name', 'Last_name', 'Email']  
 
      # using the pass in argument
      for i in 1..ARGV[1].to_i
      	 data_row = [Faker::Name::first_name, Faker::Name::last_name, Faker::Internet.email]
      	 csv << data_row
      end
    end

  end






end
