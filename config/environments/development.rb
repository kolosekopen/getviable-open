BaseApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'getviable.local:3000' }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  #config.assets.debug = true

  config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do        
    r301 %r{/how-to/.*},    'http://blog.getviable.com/how-to/$&'
    r301 %r{/how-to/.*/},    'http://blog.getviable.com/how-to/$&/'
    r301 '/meet-our-team', 'http://blog.getviable.com/meet-our-team'
    r301 '/meet-our-team/', 'http://blog.getviable.com/meet-our-team/'
    #r301 '/how-to/13-steps-to-get-viable-video-3-understanding-your-current-competitors/', 'http://blog.getviable.com'
    #r301 '/how-to/', 'http://blog.getviable.com/how-to/'
    r301 '/start-up-online-business-ideas/', 'http://blog.getviable.com/start-up-online-business-ideas/'
    r301 '/start-up-online-business-ideas', 'http://blog.getviable.com/start-up-online-business-ideas'
    r301 '/startup-portfolio/', 'http://blog.getviable.com/startup-portfolio/'
    r301 '/startup-portfolio', 'http://blog.getviable.com/startup-portfolio'
    r301 '/launch-2/startup-business-cloud-software/', 'http://blog.getviable.com/launch-2/startup-business-cloud-software/'
    r301 '/launch-2/startup-business-cloud-software', 'http://blog.getviable.com/launch-2/startup-business-cloud-software'
    r301 '/outsourcing-for-startups/', 'http://blog.getviable.com/outsourcing-for-startups/'
    r301 '/outsourcing-for-startups', 'http://blog.getviable.com/outsourcing-for-startups'
    r301 '/why-getviable/', 'http://blog.getviable.com/why-getviable/'
    r301 '/why-getviable', 'http://blog.getviable.com/why-getviable'
    r301 '/map2013/', 'http://blog.getviable.com/map2013/'
    r301 '/map2013', 'http://blog.getviable.com/map2013'
  end

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
      :login => ENV["PAYPAL_DEV_LOGIN"],
      :password => ENV["PAYPAL_DEV_PASSWORD"],
      :signature => ENV["PAYPAL_DEV_SIGNATURE"],
      :default_currency => 'USD'
    }
    ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end

