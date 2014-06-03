require 'spec_helper'

describe Invitation do
  it { should have_db_column(:invitable_id).of_type(:integer) }
  it { should have_db_column(:invitable_type).of_type(:string) }
  it { should have_db_column(:token).of_type(:string) }
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:invitee_id).of_type(:integer) }
  it { should have_db_column(:invitee_email).of_type(:string) }
  it { should have_db_column(:invitee_role_id).of_type(:integer) }
  it { should have_db_column(:active).of_type(:boolean) }
  it { should belong_to(:invitable)}
end

describe Invitation do
  before do
    @invitation = create(:invitation)
  end

  it "be active when active" do
    @invitation.active?.should be_true
  end

  it ".inactive?" do
    @invitation.inactive?.should be_false
  end

  it ".deactivate! should deactivate invitation" do
    @invitation.deactivate!
    @invitation.active?.should be_false
  end

  it "should have generated token" do
    @invitation.token.should_not be_nil
  end

  it "should send email" do
    @inv = FactoryGirl.build(:invitation)
    @inv.should_receive(:send_invitation)
    @inv.save
  end

end
