require 'spec_helper'


describe "User profile" do
  context "As signed in user" do
    login_user

    describe "profile" do
      it "should see own name", :js => true do
        visit root_path
        click_on @user.name
        click_on 'Profile'
        page.should have_content(@user.name)
      end

      it "should see Go back button on profile page", :js => true do
        visit root_path
        click_on @user.name
        click_on 'Profile'
        page.should have_content('Go back')
      end

      it "should see own setting", :js => true do
        visit root_path
        click_on @user.name
        click_on 'Settings'
        page.should have_content(@user.name)
        page.should have_content("Profile Settings")
      end

      it "should update own setting", :js => true do
        visit root_path
        click_on @user.name
        click_on 'Settings'
        fill_in "user_description", :with => "My description"
        click_on "Update"
        page.should_not have_content("Change")
        page.should have_content("My description")
        page.should_not have_content("We will not share this without your permission")
      end
    end
  end
end
