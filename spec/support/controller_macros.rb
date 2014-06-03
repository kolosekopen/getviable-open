module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryGirl.create(:admin) # Using factory girl as an example
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
      sign_in user
    end
  end

  def it_should_require_signed_in_user_for_actions(*actions)
      actions = controller_class.action_methods if actions.first == :all
      actions.delete("missing_route")
      actions.each do |action|
        it "#{action} action should require signed in user" do
          #as_signed_out_visitor
          get action.to_sym, :id => 1
          response.should redirect_to(new_user_session_path)
          #flash[:alert].should eql(I18n.t('messages.must_be_signed_in'))
        end
      end
  end
end