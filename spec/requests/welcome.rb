require 'spec_helper'


describe "Welcome" do
  context "As signed in user" do
    login_user

  end

  context "As not signed in user" do
    describe "GET /" do
      it "should see main page", :js => true do
        visit root_path
        page.should have_content('GetViable')
      end

      it "should see demo page" do
        visit root_path
        click_on "Pricing"
        page.should have_content('FREE')
      end

      it "should be able to click on help tab" do
        visit root_path
        click_on "Help"
      end

      it "should go to contact us on pricing page" do
        visit pricing_path
        page.should have_content("Contact Us")
      end
    end
  end
end
