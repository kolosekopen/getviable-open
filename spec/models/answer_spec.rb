require 'spec_helper'

describe Answer do
  it { should have_db_column(:text).of_type(:text) }
  it { should have_db_column(:short_text).of_type(:text) }
  it { should have_db_column(:help_text).of_type(:text) }

  describe "short title" do
    before do
      @answer = create(:answer, :text => "Some weeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeery loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong title")
    end

    it "should have 52 characters as short title" do
      @answer.short_title.length.should == 56
    end

    it "should show regular size when regular title is used" do
      @answer.title.length.should == 56
    end
  end
end
