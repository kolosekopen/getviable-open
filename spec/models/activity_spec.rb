require 'spec_helper'

describe Activity do
  let(:activity) { FactoryGirl.create(:activity)}
  it { should have_db_column(:idea_id).of_type(:integer) }
  it { should have_db_column(:event_type).of_type(:integer) }
  it { should have_db_column(:content).of_type(:text) }

  it { should belong_to(:idea) }

  it { should validate_presence_of(:idea_id) }

  it { should validate_presence_of(:content) }

  it { should validate_presence_of(:event_type) }

  it "should return status added" do
    Activity.status_added == Activity::STATUS_ADDED
  end

  it "should return status updated" do
    Activity.status_updated == Activity::STATUS_UPDATED
  end

  it "should return status deleted" do
    Activity.status_deleted == Activity::STATUS_DELETED
  end

  it "should return status completed" do
    Activity.status_completed == Activity::STATUS_COMPLETED
  end
end
