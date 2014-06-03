require 'spec_helper'
module IdeaSpecHelper
  def setup_idea_full_environment
    @user = FactoryGirl.create(:user_with_ideas)
    @other_user = FactoryGirl.create(:user)
    @idea = @user.ideas.first
    5.times{FactoryGirl.create(:activity, :idea_id => @idea.id)}
  end

  def setup_other_idea_activities
    idea_one = FactoryGirl.create(:idea)
    idea_two = FactoryGirl.create(:idea)
    4.times{FactoryGirl.create(:activity, :idea_id => idea_one.id)}
    3.times{FactoryGirl.create(:activity, :idea_id => idea_two.id)}
  end
end

describe Idea, "basics" do
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:description).of_type(:string) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_and_belong_to_many(:users) }


  it { should have_attached_file(:photo) }
  #it { should validate_attachment_size(:photo).less_than(5.megabytes) }

  it { should validate_attachment_content_type(:photo).
                allowing('image/png1').
                rejecting('image/gif').
                allowing('image/jpeg').
                rejecting('text/plain', 'text/xml')
  }

  it "should be valid" do
    Idea.new.should_not be_valid
  end

  it "should be valid with minimum requirements" do
    Idea.new(:title => "hello", :description => "aa").should be_valid
  end

end

describe Idea do
  include IdeaSpecHelper
  before(:each) do
    setup_idea_full_environment
  end
  before(:each) do
    setup_other_idea_activities
  end


  it ".startup! should make idea as startup" do
    @idea.startup!
    @idea.reload
    @idea.startup?.should be_true
  end

  it ".startup? should return fals if not starup" do
    @idea.startup?.should be_false
  end

  it ".startup? should return fals if not starup" do
    @idea.startup!
    @idea.startup?.should be_true
  end

  it "should tell if owner of the idea" do
    @idea.is_owner?(@other_user).should be_false
  end

  it "should tell if owner of the idea" do
    @idea.is_owner?(@user).should be_true
  end


  it "should create ideas" do
    user = FactoryGirl.create(:user_with_ideas)
    user.ideas.length.should == 5
  end

  it "should create sections" do
    #stage = FactoryGirl.create(:stage_with_sections)
    stage = Stage.first
    stage.survey_sections.length.should == 10
  end
end

describe Idea do

  it "shouldn't create idea with same title" do
    FactoryGirl.create(:idea, :title => "Title")
    duplicate = Idea.new(:title => "Title", :description => "Some description")
    duplicate.save
    duplicate.save.should be_false
  end
end

describe ".add_member" do
  include IdeaSpecHelper
  before(:each) do
    setup_idea_full_environment
  end

  before do
    @idea.users.clear
  end

  it "should add member to a team" do
    @idea.add_member(@user, 1)
    IdeasUsers.all.count == 1
    #@idea.users.should == [@user]
  end

  it "should add member to a team" do
    @idea.add_member(@user, 1)
    #@idea.users.should == [@user]
    pending "!!!Check idea.users if returning true number of users"
  end

  it "should add member to a team with specific role" do
    @idea.add_member(@user, 1)
    IdeasUsers.last.role_id.should == 1
  end

  it "should add member to a team" do
    @idea.add_member(@user, 2)
    @idea.add_member(@user, 1)
    IdeasUsers.all.count == 1
    #@idea.users.should == [@user]
  end
end

describe ".remove_member" do
  include IdeaSpecHelper
  before(:each) do
    setup_idea_full_environment
  end

  before do
    @idea.users.clear
  end

  it "should add member to a team" do
    @idea.add_member(@user, 1)
    @idea.add_member(@user, 1)
    @idea.remove_member(@user)
    @idea.users.should == []
  end
end

describe "hidden default scope" do
  before do
    create(:idea)
    create(:idea, :hidden => true)
  end

  it "should return only visible ideas" do
    Idea.all.count.should == 1
  end
end

describe ".featured!" do
  before do
    @idea = create(:idea)
  end

  it "should make idea featured" do
    @idea.featured!
    @idea.featured?.should be_true
  end

  it "shouldn't be featured" do
    @idea.featured?.should_not be_true
  end

  it "should save featured on date" do
    @idea.featured!
    @idea.featured_on.should_not be_nil
  end

end

describe ".public?" do
  before do
    @idea = create(:idea)
    @other_user = create(:user)
  end

  it "should be public if not in the team" do
    @idea.public?(@other_user).should be_true
  end

end

describe ".private?" do
  before do
    @idea = create(:idea)
    @other_user = create(:user)
  end

  it "should be private if business" do
    @idea.users << @other_user
    member = IdeasUsers.last.update_attributes(:role_id => IdeasUsers::BUSINESS)
    @idea.private?(@other_user).should be_true
  end

  it "should be private if technical" do
    @idea.users << @other_user
    member = IdeasUsers.last.update_attributes(:role_id => IdeasUsers::TECHNICAL)
    @idea.private?(@other_user).should be_true
  end

  it "should not be private if mentor" do
    @idea.users << @other_user
    member = IdeasUsers.last.update_attributes(:role_id => IdeasUsers::MENTOR)
    @idea.private?(@other_user).should be_false
  end

  it "should be private if advisor" do
    @idea.users << @other_user
    member = IdeasUsers.last.update_attributes(:role_id => IdeasUsers::ADVISOR)
    @idea.private?(@other_user).should be_false
  end
end
