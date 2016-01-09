# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

use Rack::ReverseProxy do
  reverse_proxy /^\/blog(\/.*)$/, 'http://mydomino.wpengine.com$1', :preserve_host => true

  reverse_proxy /^\/wp-admin(\/.*)$/, 'http://mydomino.wpengine.com/wp-admin/$1', :preserve_host => true
end

if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    username == 'domino' && password == 'danthepenguinstud'
  end
end

run Rails.application
