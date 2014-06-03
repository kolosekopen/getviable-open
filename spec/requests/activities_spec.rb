require 'spec_helper'

describe "Activities" do
  context "As signed in user" do
    login_user

    describe "Activities on idea" do
      before do
        @idea = FactoryGirl.create(:idea, :title => "Mine", :startup => true, :user => User.first)
        @idea_other = FactoryGirl.create(:idea, :title => "Other", :startup => true)
        FactoryGirl.create(:activity, :idea_id => @idea.id, :content => "StartingUp")
        FactoryGirl.create(:activity, :idea_id => @idea_other.id, :content => "Hidden")
      end

      context "other user" do

        it "should not show content of already created activity" do
          visit root_path
          click_on "Other"
          page.should_not have_content("StartingUp")
        end

        it "should show activity text", :js => true do
          visit root_path
          click_on "Other"
          page.should have_content("has added Idea Scope")
        end

        it "should not allow commenting on public view", :js => true do
          visit root_path
          click_on "Other"
          page.should_not have_content("comment")
        end

      end

      context "idea owner" do

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

        it "should not allow commenting", :js => true do
          visit root_path
          click_on "Mine"
          page.should_not have_content("comment")
        end

      end
    end
  end


end
