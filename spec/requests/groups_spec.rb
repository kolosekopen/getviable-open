require 'spec_helper'

describe "Groups" do
  context "As signed in user" do
    login_user

    describe "Groups on idea" do
      before do
        @idea = FactoryGirl.create(:idea, :title => "Mine", :startup => true, :user => User.first)
        @idea_other = FactoryGirl.create(:idea, :title => "Other", :startup => true)
        FactoryGirl.create(:activity, :idea_id => @idea.id, :content => "StartingUp")
        FactoryGirl.create(:activity, :idea_id => @idea_other.id, :content => "Hidden")
        @group = create(:group, :title => "Melbourne")
      end

      context "not group member" do

        it "should not show content for group activity activity", :js => true do
          visit root_path
          click_on "Activity"
          page.should_not have_content("Hey it looks like you're not connected to anyone yet.")
        end

        it "should show activity text", :js => true do
          visit root_path
          click_on "Other"
          page.should have_content("has added Idea Scope")
        end

        it "should not allow commenting", :js => true do
          visit root_path
          click_on "Other"
          page.should_not have_content("comment")
          #fill_in "comment", :with => "Very nice"
          #click_on "Submit"
          #sleep(1)
          #page.should have_content("Very nice")
        end

      end

      context "not group member" do

        it "should show content of already created activity", :js => true do
          visit root_path
          click_on "Mine"
          page.should have_content("Mine has")
        end

        it "should show activity text", :js => true do
          visit root_path
          click_on "Mine"
          page.should have_content("has added Idea Scope in Clarify idea")
        end

        it "should allow commentin", :js => true do
          visit root_path
          click_on "Mine"
          page.should_not have_content("comment")
        end

      end
    end
  end


end
