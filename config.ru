# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)


# use Rack::ReverseProxy do
#   reverse_proxy /^\/blog(\/.*)$/, 'http://mydomino.wpengine.com$1', :preserve_host => true

#   reverse_proxy /^\/wp-admin(\/.*)$/, 'http://mydomino.wpengine.com/wp-admin/$1', :preserve_host => true
# end

if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    username == 'domino' && password == 'danthepenguinstud'
  end
end

# if Rails.env.production?
#   require 'unicorn/worker_killer'

#   max_request_min = 500
#   max_request_max = 600

#   use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max

#   oom_min = (240) * (1024**2)
#   oom_max = (260) * (1024**2)

#   use Unicorn::WorkerKiller::Oom, oom_min, oom_max
# end

run Rails.application
