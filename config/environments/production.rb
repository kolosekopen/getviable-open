ActionController::Base.asset_host = Proc.new { |source|
  unless source.starts_with?('/stylesheets' || '/javascripts')
    "http://gvcdn1.getviable.com"
  end
}

BaseApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"
  config.action_mailer.default_url_options = { :host => ENV['APP_HOST_URL'] }  

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Compress both stylesheets and JavaScripts
  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :scss

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
    paypal_options = {
      :login => ENV["PAYPAL_PROD_LOGIN"],
      :password => ENV["PAYPAL_PROD_PASSWORD"],
      :signature => ENV["PAYPAL_PROD_SIGNATURE"],
      :default_currency => 'USD'
    }
    ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end
