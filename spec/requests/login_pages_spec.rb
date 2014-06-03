require 'spec_helper'

describe "Login Pages" do
	     it "should show login page" do
          visit root_path
          click_on "Login"
          page.should have_content("Sign in with Linkedin")
          page.should have_content("Sign in with Twitter")
          page.should have_content("Sign in with Facebook")
          page.should have_content("Sign up")
        end

               it "should show signup page" do
          visit root_path
          click_on "Sign up"
          page.should have_content("Sign in with Linkedin")
          page.should_not have_content("Sign in with Twitter")
          page.should have_content("Sign in with Facebook")
          page.should have_content("Sign up")
          page.should have_content("It's free to join!")
        end


end
