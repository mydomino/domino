Airbrake.configure do |config|
  config.project_key= 'a4a5ace1d75444bd9e04115b074b6c78'
  config.project_id= ENV["AIRBRAKE_PRODUCT_ID"] || '12345'
end
