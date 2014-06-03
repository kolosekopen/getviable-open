# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../config/environment',  __FILE__)

require "rack-rewrite"

if ENV['RACK_ENV'] == 'development'
  ENV['SITE_URL'] = 'getviable.local:3000'
  else
  ENV['SITE_URL'] = 'blog.getviable.com'
end


#If you want all traffic to redirect
#  r301 %r{.*}, 'http://blog.getviable.com$&', lambda {|rack_env|
#  rack_env['SERVER_NAME'] != 'blog.getviable.com'
#}



run BaseApp::Application
