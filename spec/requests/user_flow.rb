require 'spec_helper'


describe "User new idea" do
  context "As signed in user" do
    login_user

    describe "Going trough pages" do
      it "should see empty ideas", :js => true do
        visit root_path
        page.should_not have_content('ADD NEW IDEA')
      end

      it "should see all ideas grouped" do
        visit root_path
        page.should have_content('All Featured')
        page.should have_content('All newest')
        page.should have_content('All most active')
      end

      it "should logut when click logout", :js => true do
        visit root_path
        click_on @user.name
        click_on 'Sign out'
        page.should_not have_content(@user.name)
      end
    end
  end
end
