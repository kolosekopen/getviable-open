require 'spec_helper'

describe ExpertRequest do

  it { should have_db_column(:support_type).of_type(:integer) }
  it { should have_db_column(:subject).of_type(:string) }
  it { should have_db_column(:problem).of_type(:text) }
  it { should have_db_column(:terms_conditions).of_type(:boolean) }
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:code).of_type(:string) }
  it { should have_db_column(:idea_id).of_type(:integer) }
  it { should have_db_column(:survey_section_id).of_type(:integer) }

  it { should belong_to(:idea) }
  it { should belong_to(:user) }

  let(:user) { create(:user) }
  let(:idea) { create(:idea) }

  describe ".generate_code" do
    before do
      @expert_request = build(:expert_request, :user_id => user.id, :idea_id => idea.id)
    end

    it "should create a code for expert request" do
      @expert_request.code.should be_nil
      @expert_request.save
      @expert_request.code.should_not be_nil
    end
  end

  describe ".paid!" do
    before do
      @expert_request = create(:expert_request, :user_id => user.id, :idea_id => idea.id)
    end

    it "deprecated method raise no method error message" do
      expect {  @expert_request.paid! }.to raise_error(NoMethodError)
    end

  end
end
