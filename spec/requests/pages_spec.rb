require 'spec_helper'

describe "Pages" do
  context "not logged in" do
    describe "accessible pages" do
      it "should show pricing page" do
        visit root_path
        click_on "Pricing"
        page.should have_content("Access the full power of GetViable!")
        page.should have_content("We're helping people just like you!")
      end

      it "should show About us page" do
        visit root_path
        click_on "About Us"
        page.should have_content("Meet the Founders")
        page.should have_content("Why Have We Built GetViable?")
        page.should have_content("Leslie Barry")
        page.should have_content("Dougal Edwards")
      end

      it "should show About us page" do
        visit root_path
        click_on "Help"
      end

      it "should show Terms and Conditions" do
        visit root_path
        click_on "Terms and Conditions"
        page.should have_content("TERMS OF SERVICE")
        page.should have_content("General Terms.")
      end

      it "should show privacy policy" do
        visit root_path
        click_on "Privacy Policy"
        page.should have_content("fundamental principles")
        page.should have_content("Cookies")
      end

      it "should show Home when clicking on home" do
        visit root_path
        click_on "Home"
        page.should have_content("Startup Your Idea Today")
      end
    end
  end

  context "logged in user" do
    login_user
    describe "accessible pages" do

      it "should show Terms and Conditions" do
        visit root_path
        click_on "Terms and Conditions"
        page.should have_content("TERMS OF SERVICE")
        page.should have_content("General Terms.")
      end

      it "should show privacy policy" do
        visit root_path
        click_on "Privacy Policy"
        page.should have_content("fundamental principles")
        page.should have_content("Cookies")
      end
    end
  end
end
