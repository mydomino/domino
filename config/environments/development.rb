Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  config.action_mailer.default_url_options = { :host => 'localhost', :port => 3000 }
  # User mailcatcher for email debugging
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  
  #Mailcatcher!
  config.action_mailer.delivery_method = :smtp
  #config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  # use gmail account to send emai locally - Yong
  # config.action_mailer.smtp_settings = {
  #   address:              'smtp.gmail.com',
  #   port:                 587,
  #   domain:               'mydomino.com',
  #   user_name:            ENV["GMAIL_USERNAME"],
  #   password:             ENV["GMAIL_PASSWORD"],
  #   authentication:       'plain',
  #   enable_starttls_auto: true  
  # }

  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
  end

  # completely disable web_console whiny_requests for display with ips - Yong
  config.web_console.whiny_requests = false

  # set the default host for url_helpers method
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
  Rails.application.routes.default_url_options[:protocol]= 'http'

  # Set the time zone to other zone so we can catch time zone bug in our local environment
  config.time_zone = 'Central Time (US & Canada)'
end
