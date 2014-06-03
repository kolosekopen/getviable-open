require 'spec_helper'

describe CustomEmail do
  describe 'assigning custom email to new user' do
  	let!(:user) { create(:user) }
    specify { user.custom_email.should_not be_nil }
    specify { user.custom_email.original_email.should eq(user.email) }
    specify { user.custom_email.custom_email.should eq(user.email) }
  end

  describe CustomEmail, '#original_with_custom' do
    let!(:user) { create(:user, email: 'vuk.gladni@gmail.com') }

    it 'returns one custom_email object' do
      #user.custom_email.original_with_custom.size.should eq(1)
      CustomEmail.where(original_email: user.custom_email.custom_email).size.should eq(1)
    end
  end
end
