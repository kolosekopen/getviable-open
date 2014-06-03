require 'spec_helper'

module ExpertRequestsHelper
  def paid_package_idea_title(title)
    @idea = Idea.where(title: title).try(:first)
    @package = @idea.package
    @package.set_platinum_package!
  end
end

describe "ExpertRequests" do
  include ExpertRequestsHelper

  context "As signed in user" do
    login_user

    context 'when paid package' do
      describe "Creating new idea" do
        it "should be able to see expert request page", :js => true do
          visit ideas_path
          click_on 'ADD AN IDEA'
          fill_in "idea_title", :with => "DifferentApp"
          fill_in "idea_description", :with => "My super awesome description"
          click_on 'Create'
          page.should have_content("DifferentApp")
          paid_package_idea_title("DifferentApp")
          visit current_path
          pending "Pending test"
          #page.should have_content("DifferentApp")
          #page.should have_content("Silver")
          #page.should have_content("UPGRADE")
        end

        #TODO Add PayPal mock urls
        it "should be able to ask expert", :js => true do
          resp = {:timestamp=>"2013-03-18T12:19:14Z", :ack=>"Success", :correlation_id=>"d68703f460745", :version=>"72", :build=>"5451042", :token=>"EC-2K741719LJ     224105N", "Timestamp"=>"2013-03-18T12:19:14Z", "Ack"=>"Success", "CorrelationID"=>"d68703f460745", "Version"=>"72", "Build"=>"5451042", "Token"=>"EC-2K741719L     J224105N"}
          resp = resp.to_xml.to_s
          #stub_request(:post, "https://api-3t.sandbox.paypal.com/2.0/").with(:body => /.*SetExpressCheckout.*/).to_return(:body => resp)
          visit ideas_path
          click_on 'ADD AN IDEA'
          fill_in "idea_title", :with => "DifferentApp"
          fill_in "idea_description", :with => "My super awesome description"
          click_on 'Create'
          page.should have_content("DifferentApp")
          paid_package_idea_title("DifferentApp")
          visit current_path
          page.should have_content("DifferentApp")
          pending "Should finish this test"
          #click_on "Ask expert"
          #fill_in "expert_request_problem", :with => "My Problem"
          #page.check "expert_request_terms_conditions"
          #click_on "Ask an expert"
          #page.should_not have_content("What would you like to ask about")
        end

        it "should be able to ask expert with unknown type", :js => true do
          resp = {:timestamp=>"2013-03-18T12:19:14Z", :ack=>"Success", :correlation_id=>"d68703f460745", :version=>"72", :build=>"5451042", :token=>"EC-2K741719LJ     224105N", "Timestamp"=>"2013-03-18T12:19:14Z", "Ack"=>"Success", "CorrelationID"=>"d68703f460745", "Version"=>"72", "Build"=>"5451042", "Token"=>"EC-2K741719L     J224105N"}
          resp = resp.to_xml.to_s
          #stub_request(:post, "https://api-3t.sandbox.paypal.com/2.0/").with(:body => /.*SetExpressCheckout.*/).to_return(:body => resp)
          visit ideas_path
          click_on 'ADD AN IDEA'
          fill_in "idea_title", :with => "DifferentApp"
          fill_in "idea_description", :with => "My super awesome description"
          click_on 'Create'
          page.should have_content("DifferentApp")
          paid_package_idea_title("DifferentApp")
          visit current_path
          page.should have_content("DifferentApp")
          pending "Should finish this test"
          #click_on "Ask expert"
          #select('Other (specify below)', :from => 'expert-type')
          #fill_in "expert_request_subject", :with => "My subject"
          #fill_in "expert_request_problem", :with => "My Problem"
          #page.check "expert_request_terms_conditions"
          #click_on "Ask an expert"
          #page.should_not have_content("What would you like to ask about")
        end

        it "should receive error when going to ask expert without params" do
          visit new_expert_request_path
          page.should have_content("Something went wrong")
        end
      end
    end

    context 'when free package' do
      describe "Creating new idea" do
        it "should be able to see expert request page", :js => true do
          visit ideas_path
          click_on 'ADD AN IDEA'
          fill_in "idea_title", :with => "DifferentApp"
          fill_in "idea_description", :with => "My super awesome description"
          click_on 'Create'
          page.should have_content("DifferentApp")
          page.should_not have_content("Ask expert")
        end

        it "should return to same page if T&C not checked", :js => true do
          visit ideas_path
          click_on 'ADD AN IDEA'
          fill_in "idea_title", :with => "DifferentApp"
          fill_in "idea_description", :with => "My super awesome description"
          click_on 'Create'
          page.should have_content("DifferentApp")
          page.should_not have_content("Ask expert")
        end

        #TODO Add PayPal mock urls
        it "should not be able to ask expert", :js => true do
          resp = {:timestamp=>"2013-03-18T12:19:14Z", :ack=>"Success", :correlation_id=>"d68703f460745", :version=>"72", :build=>"5451042", :token=>"EC-2K741719LJ     224105N", "Timestamp"=>"2013-03-18T12:19:14Z", "Ack"=>"Success", "CorrelationID"=>"d68703f460745", "Version"=>"72", "Build"=>"5451042", "Token"=>"EC-2K741719L     J224105N"}
          resp = resp.to_xml.to_s
          #stub_request(:post, "https://api-3t.sandbox.paypal.com/2.0/").with(:body => /.*SetExpressCheckout.*/).to_return(:body => resp)
          visit ideas_path
          click_on 'ADD AN IDEA'
          fill_in "idea_title", :with => "DifferentApp"
          fill_in "idea_description", :with => "My super awesome description"
          click_on 'Create'
          page.should have_content("DifferentApp")
          page.should_not have_content("Ask expert")
        end

        it "should receive error when going to ask expert without params" do
          visit new_expert_request_path
          page.should have_content("Something went wrong")
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
