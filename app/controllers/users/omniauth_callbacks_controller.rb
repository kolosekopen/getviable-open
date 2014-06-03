class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  layout 'login'
#   {
#   :provider => 'facebook',
#   :uid => '1234567',
#   :info => {
#     :nickname => 'jbloggs',
#     :email => 'joe@bloggs.com',
#     :name => 'Joe Bloggs',
#     :first_name => 'Joe',
#     :last_name => 'Bloggs',
#     :image => 'http://graph.facebook.com/1234567/picture?type=square',
#     :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
#     :location => 'Palo Alto, California',
#     :verified => true
#   },
#   :credentials => {
#     :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
#     :expires_at => 1321747205, # when the access token expires (it always will)
#     :expires => true # this will always be true
#   },
#   :extra => {
#     :raw_info => {
#       :id => '1234567',
#       :name => 'Joe Bloggs',
#       :first_name => 'Joe',
#       :last_name => 'Bloggs',
#       :link => 'http://www.facebook.com/jbloggs',
#       :username => 'jbloggs',
#       :location => { :id => '123456789', :name => 'Palo Alto, California' },
#       :gender => 'male',
#       :email => 'joe@bloggs.com',
#       :timezone => -8,
#       :locale => 'en_US',
#       :verified => true,
#       :updated_time => '2011-11-11T06:21:03+0000'
#     }
#   }
# }
  def facebook
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    if @user.valid?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_session_url, :notice => %Q[An account already exists with this email address. Have you already connected with another social network? If so, please connect with that network. If not, please <a href=\"http://support.getviable.com\" target = '_blank'>contact us</a> for assistance.].html_safe
    end
  end

  def twitter
    @user = User.find_for_twitter_oauth(omniauth, current_user)

    if @user.valid?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.twitter_data"] = env["omniauth.auth"]
      redirect_to new_user_session_url, :notice => %Q[An account already exists with this email address. Have you already connected with another social network? If so, please connect with that network. If not, please <a href=\"http://support.getviable.com\" target = '_blank'>contact us</a> for assistance.].html_safe
    end
  end

  def linkedin
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.valid?
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_session_url, :notice => %Q[An account already exists with this email address. Have you already connected with another social network? If so, please connect with that network. If not, please <a href=\"http://support.getviable.com\" target = '_blank'>contact us</a> for assistance.].html_safe
    end
  end

  def omniauth
    env['omniauth.auth']
  end

    def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end
