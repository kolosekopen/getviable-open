ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'smtp.mandrillapp.com',
  :port => 587,
  :domain => 'getviable.com',
  :authentication => :plain,
  :user_name =>      ENV['MANDRILL_USERNAME'],
  :password =>       ENV['MANDRILL_APIKEY']
}

ActionMailer::Base.default_url_options[:host] = "getviable.local:3000" unless Rails.env.production?