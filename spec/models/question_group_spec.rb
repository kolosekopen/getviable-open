require 'spec_helper'

describe QuestionGroup do
  it { should have_db_column(:text).of_type(:text) }

  describe "short title" do
    before do
      @question_group = create(:question_group, :text => "Some weeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeery loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong title")
    end

    it "should have 52 characters as short title" do
      @question_group.short_title.length.should == 54
    end

    it "should show regular size when regular title is used" do
      @question_group.title.length.should == 55
    end
  end
end
