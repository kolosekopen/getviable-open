require 'spec_helper'
#include Warden::Test::Helpers


describe "Ideas" do
  context "As signed in user" do
    login_user

    before do
      @current_user = User.first
    end

    describe "GET /" do
      it "should load root dashboard even when no ideas" do
        visit root_path
        page.should have_content("Featured")
      end

    end

    describe "GET /ideas" do
      it "should see list of ideas", :js => true do
        visit ideas_path
        page.should have_content('No Ideas Saved')
      end

      it "should be able to create first idea", :js => true do
        visit ideas_path
        page.should have_content('ADD AN IDEA')
        click_on 'ADD AN IDEA'
        page.should have_content("Public Description")
      end

      it "should be able to create first idea", :js => true do
        visit ideas_path
        page.should have_content('New Idea')
        click_on 'New Idea'
        page.should have_content("Public Description")
      end
    end

    describe "Creating new idea" do
      it "should create new idea because survey is present", :js => true do
        visit ideas_path
        click_on 'ADD AN IDEA'
        fill_in "idea_title", :with => "DifferentApp"
        fill_in "idea_description", :with => "My super awesome description"
        click_on 'Create'
        page.should have_content("DifferentApp")
      end
    end

    describe "Upgrading the idea to one of the packages" do
      before do
        visit ideas_path
        click_on 'ADD AN IDEA'
        fill_in "idea_title", :with => "DifferentApp"
        fill_in "idea_description", :with => "My super awesome description"
        click_on 'Create'
        page.should have_content("DifferentApp")
        @idea = Idea.first
      end
      context "own idea" do

        it "doesn't shows upgrade package when going to first stage", :js => true do
          visit root_path
          click_on "Your Ideas"
          click_on "DifferentApp"
          page.should have_content("Idea Scope")
          visit edit_tour_path(:idea_id => @idea.id, :section => 1)
          page.should_not have_content("Choose From One Of These Great Startup Packages!")
        end

        it "shows upgrade package when going to second stage", :js => true do
          visit root_path
          click_on "Your Ideas"
          click_on "DifferentApp"
          page.should have_content("Idea Scope")
          visit edit_tour_path(:idea_id => @idea.id, :section => 11)
          page.should have_content("Choose From One Of These Great Startup Packages!")
        end

        it "shows upgrade package when going to third stage", :js => true do
          visit root_path
          click_on "Your Ideas"
          click_on "DifferentApp"
          page.should have_content("Idea Scope")
          visit edit_tour_path(:idea_id => @idea.id, :section => 16)
          page.should have_content("Choose From One Of These Great Startup Packages!")
        end

        it "shows upgrade package when going to 4th stage", :js => true do
          visit root_path
          click_on "Your Ideas"
          click_on "DifferentApp"
          page.should have_content("Idea Scope")
          visit edit_tour_path(:idea_id => @idea.id, :section => 23)
          page.should have_content("Choose From One Of These Great Startup Packages!")
        end

        it "shows upgrade package when going to 5th stage", :js => true do
          visit root_path
          click_on "Your Ideas"
          click_on "DifferentApp"
          page.should have_content("Idea Scope")
          visit edit_tour_path(:idea_id => @idea.id, :section => 26)
          page.should have_content("Choose From One Of These Great Startup Packages!")
        end

        it "shows upgrade package when going to edit idea", :js => true do
          visit root_path
          click_on "Your Ideas"
          click_on "DifferentApp"
          click_on "Idea Profile"
          click_on "Edit Idea"
          page.should have_content("Choose From One Of These Great Startup Packages!")
        end
      end
    end

    describe "Listing startup on Dashboard" do
      before do
        FactoryGirl.create(:idea, :title => "Something", :startup => true, :user => @current_user)
        FactoryGirl.create(:idea, :title => "Other", :startup => true)
      end

      it "should list existing ideas" do
        visit root_path
        page.should have_content("Something")
      end

      context "own idea" do

        it "should visit others existing idea and not show work on startup link", :js => true do
          visit root_path
          click_on "Something"
          page.should_not have_content("Work on Startup")
        end

        it "should visit my existing idea and show dashboard", :js => true do
          visit root_path
          click_on "Something"
          page.should have_content("Dashboard")
        end

        it "should visit others existing idea and show their activity", :js => true do
          visit root_path
          click_on "Something"
          page.should have_content("Activity")
        end
      end

      context "accessing other's idea" do

        it "should visit others existing idea and not show work on startup link" do
          visit root_path
          click_on "Other"
          page.should_not have_content("Work on startup")
        end

        it "should visit others existing idea and not show dashboard" do
          visit root_path
          # click_on "Other"
          # page.should_not have_content("Dashboard")
          click_on "Activity"
          page.should_not have_content("Featured")
        end

        it "should visit others existing idea and show their activity" do
          visit root_path
          # click_on "Other"
          # page.should have_content("Activity")
          click_on "Activity"
          page.should have_content("All Connections")
        end

      end

    end
  end

  context "As not signed in user" do
    describe "GET /ideas" do
      it "should see list of ideas" do
        get ideas_path
        response.status.should_not be(200)
      end
    end
  end
end

