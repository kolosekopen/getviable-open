require 'spec_helper'
describe "PayPal express" do
  context "As logged in user" do
    login_user

    it "should successfully forward to PayPal", :js => true do
      #resp = File.new(File.join(File.dirname(__FILE__),"../webmock_stubs/paypal_checkout_ok_response.xml"))
      #data = File.read(Rails.root + "spec/webmock_stubs/paypal_checkout_ok_response.json")
      resp = {:timestamp=>"2013-03-18T12:19:14Z", :ack=>"Success", :correlation_id=>"d68703f460745", :version=>"72", :build=>"5451042", :token=>"EC-2K741719LJ224105N", "Timestamp"=>"2013-03-18T12:19:14Z", "Ack"=>"Success", "CorrelationID"=>"d68703f460745", "Version"=>"72", "Build"=>"5451042", "Token"=>"EC-2K741719LJ224105N"}
      resp = resp.to_xml.to_s

      stub_request(:post, "https://api-3t.sandbox.paypal.com/2.0/").with(:body => /.*SetExpressCheckout.*/).to_return(:body => resp)
      stub_request(:post, "https://api-3t.sandbox.paypal.com/2.0/").with(:body => /.*GetExpressCheckoutDetails.*/).to_return(:body => File.new(File.join(File.dirname(__FILE__),"../webmock_stubs/paypal_details_ok_response.xml")))
      stub_request(:post, "https://api-3t.sandbox.paypal.com/2.0/").with(:body => /.*DoExpressCheckoutPayment.*/).to_return(:body => File.new(File.join(File.dirname(__FILE__),"../webmock_stubs/paypal_purchase_ok_response.xml")))

      #stub_request(:any, "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-8V342075SP7886819").to_return(
      #	:body => File.new(File.join(File.dirname(__FILE__),"../webmock_stubs/paypal_purchase_ok_response.xml")), :status => 200)
      #visit 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-8V342075SP7886819'
      token = "EC-3FW39378TY823225R"
      payer = "9K4KRSTUSZDGU"

      visit new_expert_request_path

    end
  end

end
