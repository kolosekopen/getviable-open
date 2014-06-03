require 'spec_helper'

describe User do

  it { should have_db_column(:email).of_type(:string) }
  it { should have_db_column(:encrypted_password).of_type(:string) }
  it { should have_db_column(:reset_password_token).of_type(:string) }
  it { should have_db_column(:remember_created_at).of_type(:datetime) }
  it { should have_db_column(:sign_in_count).of_type(:integer) }
  it { should have_db_column(:current_sign_in_at).of_type(:datetime) }
  it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
  it { should have_db_column(:current_sign_in_ip).of_type(:string) }
  it { should have_db_column(:last_sign_in_ip).of_type(:string) }

  it { should have_and_belong_to_many(:roles) }
  it { should have_many(:ideas) }

  let(:user) { create(:user) }

  let(:admin_role) { create(:role, :name => "admin") }
  let(:customer_role) { create(:role, :name => "customer") }

  describe ".role?" do

    context "user has asked role" do

      before do
        user.roles.clear
        user.roles << admin_role
      end

      it "returns true" do
        user.role?(admin_role.name).should be_true
      end

    end

    context "user doesn't have asked role" do

      before do
        user.roles.clear
        user.roles << customer_role
      end

      it "returns false" do
        user.role?(admin_role.name).should be_false
      end

    end

  end

  describe ".make_admin" do

    before do
      Role.find_or_create_by_name("admin")
      user.make_admin
    end

    it "adds admin role to user" do
      user.should be_admin
    end

  end

  describe ".revoke_admin" do

    before do
      Role.find_or_create_by_name("admin")
      user.make_admin
      user.revoke_admin
    end

    it "removes admin role from user" do
      user.should_not be_admin
    end

  end

  describe ".admin?" do

    before do
      user.roles.clear
    end

    it "returns true if user is admin" do
      user.roles << admin_role
      user.admin?.should be_true
    end

    it "returns false is user is not admin" do
      user.roles << customer_role
      user.admin?.should be_false
    end

  end


  describe "valid" do

    before do
      @access_token = {
   :provider => 'facebook',
   :uid => '1234567',
   :info => {
     :nickname => 'jbloggs',
     :email => 'joe@bloggs.com',
     :name => 'Joe Bloggs',
     :first_name => 'Joe',
     :last_name => 'Bloggs',
     :image => 'http://graph.facebook.com/1234567/picture?type=square',
     :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
     :location => 'Palo Alto, California',
     :verified => true
   },
   :credentials => {
     :token => 'ABCDEF...',
     :expires_at => 1321747205,
     :expires => true
   },
   :extra => {
     :raw_info => {
       :id => '1234567',
       :name => 'Joe Bloggs',
       :first_name => 'Joe',
       :last_name => 'Bloggs',
       :link => 'http://www.facebook.com/jbloggs',
       :username => 'jbloggs',
       :location => { :id => '123456789', :name => 'Palo Alto, California' },
       :gender => 'male',
       :email => 'joe@bloggs.com',
       :timezone => -8,
       :locale => 'en_US',
       :verified => true,
       :updated_time => '2011-11-11T06:21:03+0000'
     }
   }
 }
      @user = FactoryGirl.create(:user, :email => "joe@bloggs.com")
    end

    subject { @user }

    it "is invalid without email" do
      subject.email = nil
      subject.should be_valid
    end

    it "should not raise record invalid if email wrong" do
      expect { create(:user, :email => nil)}.to_not raise_error(ActiveRecord::RecordInvalid)
    end

    it "should return false if not persistent" do
      user = FactoryGirl.build(:user, :email => @user.email)
      user.persisted?.should be_false
    end

    it "should be good" do
      expect {  User.find_for_facebook_oauth(@access_token, signed_in_resource=nil)}.to_not raise_error(ActiveRecord::RecordInvalid)
    end

  end


  describe "add to group" do
    before do
      user.groups.clear
      @group = create(:group)
    end

    it "should add user to specific group" do
      user.add_to_group(@group)
      user.groups.should == [@group]
    end

    it "should remove user from specific group" do
      user.add_to_group(@group)
      user.remove_from_group(@group)
      user.groups.should == []
    end
  end

  describe ".needs_password?" do
    it "should not ask for update password" do
      user.needs_password?.should be_false
    end
  end

  describe ".has_role?" do
    it "should have role" do
      user.roles.clear
      user.make_admin
      user.has_role?.should be_true
    end

    it "shouldn't have role" do
      user.roles.clear
      user.has_role?.should be_false
    end
  end

  describe ".is_entity?" do
    it "should confirm that it's same user" do
      user.is_entity?(user)
    end

    it "should say it's not same user" do
      other_user = create(:user)
      user.is_entity?(other_user).should be_false
    end
  end

  describe ".group?" do
    before do
      @group = create(:group)
    end

    it "should say user is not part of that group" do
      user.group?(@group.id).should be_false
    end

    it "should confirm user is part of that group" do
      user.add_to_group(@group)
      user.group?(@group.id).should be_true
    end
  end

end
