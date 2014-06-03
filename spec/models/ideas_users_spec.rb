require 'spec_helper'

describe IdeasUsers do

  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:idea_id).of_type(:integer) }
  it { should have_db_column(:role_id).of_type(:integer) }

  it { should belong_to(:user) }
  it { should belong_to(:idea) }

  describe ".public?" do
    before do
      @team = create(:ideas_users)
    end

    it "should not make public for this role" do
      @team.update_attributes(:role_id => 1)
      @team.public?.should be_false
    end

    it "should not make public for this role" do
      @team.update_attributes(:role_id => 2)
      @team.public?.should be_false
    end

    it "should not make public for this role" do
      @team.update_attributes(:role_id => 3)
      @team.public?.should be_false
    end

    it "should make private for this role" do
      @team.update_attributes(:role_id => 1)
      @team.private?.should be_true
    end

    it "should make private for this role" do
      @team.update_attributes(:role_id => 2)
      @team.private?.should be_true
    end

    it "should make private for this role" do
      @team.update_attributes(:role_id => 3)
      @team.private?.should be_true
    end
  end

  describe ".private?" do
    before do
      @team = create(:ideas_users)
    end

    it "should make public for this role" do
      @team.update_attributes(:role_id => 4)
      @team.public?.should be_true
    end

    it "should make public for this role" do
      @team.update_attributes(:role_id => 5)
      @team.public?.should be_true
    end

    it "should make public for this role" do
      @team.update_attributes(:role_id => 6)
      @team.public?.should be_true
    end

    it "should not make private for this role" do
      @team.update_attributes(:role_id => 4)
      @team.private?.should be_false
    end

    it "should make private for this role" do
      @team.update_attributes(:role_id => 5)
      @team.private?.should be_false
    end

    it "should make private for this role" do
      @team.update_attributes(:role_id => 6)
      @team.private?.should be_false
    end
  end
end
