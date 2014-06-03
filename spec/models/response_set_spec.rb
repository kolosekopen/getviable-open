require 'spec_helper'

describe ResponseSet do
  it { should have_db_column(:survey_id).of_type(:integer) }
  it { should have_db_column(:idea_id).of_type(:integer) }
  #let {:ui_hash} {"{"4"=>{"question_id"=>"4", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4fd", "answer_id"=>[""]},
  #"5"=>{"question_id"=>"4", "api_id"=>"12f8f15d-148a-4c03-a045-2aba63e9bf69", "answer_id"=>["", "5"]}}"}

  describe ".record_activity!" do
    before do
      @response_set = create(:response_set)
      @survey_section = create(:survey_section)
      @question_first = create(:question, :survey_section_id => @survey_section.id)
      @question_second = create(:question, :survey_section_id => @survey_section.id)
      #@question_third = create(:question, :survey_section_id => nil)
      create(:response, :api_id => "66108d6a-dd77-4259-94bd-93a73c70c4fd", :question_id => @question_first.id)#, :response_set => @response_set.id)
      create(:response, :api_id => "12f8f15d-148a-4c03-a045-2aba63e9bf69", :question_id => @question_second.id)#, :response_set => @response_set.id)
      #create(:response, :api_id => "12f8f15d-148a-4c03-a045-2aba63e9bf67", :question_id => @question_third.id)#, :response_set => @response_set.id)
      @ui_hash = {"4"=>{"question_id"=>"#{@question_first.id}", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4fd", "answer_id"=>"1", "string_value" => "hello"}, "5"=>{"question_id"=>"#{@question_second.id}", "api_id"=>"12f8f15d-148a-4c03-a045-2aba63e9bf69", "answer_id"=>["", "5"]}}
    end

    it "should raise error if question that was tried to be updates is not actual the same question" do
      @ui_hash = {"1"=>{"question_id"=>"99999", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4fd", "answer_id"=>"1", "string_value"=>"hello"}, "2"=>{"question_id"=>"2", "api_id"=>"12f8f15d-148a-4c03-a045-2aba63e9bf69", "answer_id"=>["", "5"]}}
      lambda {@response_set.update_from_ui_hash(@ui_hash)}.should raise_error(RuntimeError)
    end

    it "should not raise  error if question that was tried to be updates is actual the same question" do
      lambda {@response_set.update_from_ui_hash(@ui_hash)}.should_not raise_error(RuntimeError)
    end

    it "should update with the new answer" do
      @response_set.update_from_ui_hash(@ui_hash)
      existing = Response.first
      existing.string_value.should == "hello"
    end

    it "should destroy response if answer to question is deleted" do
      @response_set.update_from_ui_hash(@ui_hash)
      Response.where(:api_id => "66108d6a-dd77-4259-94bd-93a73c70c4fd").should_not == []
      @ui_hash = {"1"=>{"question_id"=>"#{@question_first.id}", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4fd", "answer_id"=>"1", "string_value"=>""}, "2"=>{"question_id"=>"#{@question_second.id}", "api_id"=>"12f8f15d-148a-4c03-a045-2aba63e9bf69", "answer_id"=>["", "5"]}}
      @response_set.update_from_ui_hash(@ui_hash)
      Response.where(:api_id => "66108d6a-dd77-4259-94bd-93a73c70c4fd").should == []
    end

    it "should create new response if new answer is given" do
      @ui_hash = {"1"=>{"question_id"=>"4", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4ff", "answer_id"=>"4", "string_value"=>"Hi"}}
      Response.all.size.should == 2
      @response_set.update_from_ui_hash(@ui_hash)
      Response.all.size.should == 3
    end

    it "should create activity when something is added" do
      Activity.all.size.should == 0
      @ui_hash = {"1"=>{"question_id"=>"4", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4ff", "answer_id"=>"4", "string_value"=>"Hi"}}
      @response_set.update_from_ui_hash(@ui_hash)
      Activity.all.size.should == 1
    end

    it "should create activity content when something is added" do
      @ui_hash = {"1"=>{"question_id"=>"4", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4ff", "answer_id"=>"4", "string_value"=>"Hi"}}
      @response_set.update_from_ui_hash(@ui_hash)
      Activity.first.content.should == "<b>What constraints do you have to building your business?</b> - Hi\n"
    end

    it "should update activity when something is added right after" do
      Activity.all.size.should == 0
      @ui_hash = {"1"=>{"question_id"=>"4", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4ff", "answer_id"=>"4", "string_value"=>"Hi"}}
      @response_set.update_from_ui_hash(@ui_hash)
      Activity.all.size.should == 1
      @response_set.update_from_ui_hash(@ui_hash)
      Activity.all.size.should == 1
    end

    it "should create notification when something is added" do
      PublicActivity::Activity.all.size.should == 0
      @ui_hash = {"1"=>{"question_id"=>"4", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4ff", "answer_id"=>"4", "string_value"=>"Hi"}}
      @response_set.update_from_ui_hash(@ui_hash)
      PublicActivity::Activity.all.size.should == 1
    end

    it "should not create activity when something is added" do
      Activity.all.size.should == 0
      @ui_hash = {"1"=>{"question_id"=>"3", "api_id"=>"66108d6a-dd77-4259-94bd-93a73c70c4ff", "answer_id"=>"3", "string_value"=>"Hi"}}
      @response_set.update_from_ui_hash(@ui_hash)
      Activity.all.size.should == 1
    end
  end
end
