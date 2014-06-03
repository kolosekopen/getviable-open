require 'spec_helper'
#include Warden::Test::Helpers


describe "Ideas" do
  context "As signed in user" do
    login_user

    before do
      @current_user = User.first
    end

    describe "Listing startup on Dashboard" do
      context "member of an idea as Technical role" do
        before do
          other_user = create(:user)
          FactoryGirl.create(:idea, :title => "Something", :startup => true, :user => @current_user)
          FactoryGirl.create(:idea, :title => "Other", :startup => true)
          @team_idea = FactoryGirl.create(:idea, :title => "TeamIdea", :startup => true, :user => other_user)
          @team_idea.add_member(@current_user, IdeasUsers::TECHNICAL)
        end

        it "should list existing ideas" do
          visit root_path
          page.should have_content("Something")
        end

        context "own idea" do

          it "should visit own idea and be able to edit", :js => true do
            visit root_path
            click_on "Something"
            click_on "Idea Profile"
            page.should have_content("Edit Idea")
          end

          it "should visit my edit idea page", :js => true do
            visit root_path
            click_on "Something"
            click_on "Idea Profile"
            click_on "Edit Idea"
            page.should have_content "Edit Idea Team"
            page.should have_content "Edit Idea Profile"
          end

          it "should edit idea", :js => true do
            visit root_path
            click_on "Something"
            click_on "Idea Profile"
            click_on "Edit Idea"
            fill_in "idea_title", :with => "DifferentOne"
            fill_in "idea_description", :with => "Nice"
            click_on "Save profile"
            page.should have_content "DifferentOne"
            page.should have_content "Nice"
          end
        end

        context "accessing other's idea" do

          it "should visit others existing idea and not show work on startup link" do
            visit root_path
            click_on "Other"
            page.should_not have_content("Edit idea")
          end

          it "shouldn't show me edit team option even if in same team" do
            visit root_path
            click_on "Something"
            page.should_not have_content "Edit idea"
          end

        end

      end
    end
  end

  context "As not signed in user" do
    describe "GET /ideas_users" do
      pending "Non part of team can't access this controller"
    end
  end
end

