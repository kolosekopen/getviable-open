require 'spec_helper'
module StageSpecHelper
  def setup_stage_full_environment
    #5.times{FactoryGirl.create(:stage_with_sections)} unless Stage.all.count == 5
    @stages = Stage.all
    @idea = FactoryGirl.create(:idea)
  end
end

describe Stage do
  it { should have_db_column(:color).of_type(:string) }
  it { should have_db_column(:description).of_type(:text) }
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:image).of_type(:string) }
  #it { should validate_presence_of(:title) }
  #it { should validate_presence_of(:description) }

end

describe Stage, "colors" do
  include StageSpecHelper
  before(:each) do
    setup_stage_full_environment
  end

  it ".color_name? clarify should be green" do
    stage = Stage.find_by_image('clarify')
    stage.color_name?.should == "green"
  end

  it ".color_name? clarify should not be blue" do
    stage = Stage.find_by_image('clarify')
    stage.color_name?.should_not == "blue"
  end

  it ".color_name? clarify should not be green" do
    stage = Stage.find_by_image('clarify')
    stage.color_name?.should_not == "yellow"
  end

  it ".color_name? clarify should not be red" do
    stage = Stage.find_by_image('clarify')
    stage.color_name?.should_not == "red"
  end

  it ".color_name? clarify should not be teal" do
    stage = Stage.find_by_image('clarify')
    stage.color_name?.should_not == "teal"
  end

  #Target
  it ".color_name? target should be blue" do
    stage = Stage.find_by_image('target')
    stage.color_name?.should == "blue"
  end

  it ".color_name? target should not be green" do
    stage = Stage.find_by_image('target')
    stage.color_name?.should_not == "green"
  end

  it ".color_name? target should not be green" do
    stage = Stage.find_by_image('target')
    stage.color_name?.should_not == "yellow"
  end

  it ".color_name? target should not be red" do
    stage = Stage.find_by_image('target')
    stage.color_name?.should_not == "red"
  end

  it ".color_name? target should not be teal" do
    stage = Stage.find_by_image('target')
    stage.color_name?.should_not == "teal"
  end

  #Discovery
  it ".color_name? discovery should be yellow" do
    stage = Stage.find_by_image('discovery')
    stage.color_name?.should == "yellow"
  end

  it ".color_name? discovery should not be green" do
    stage = Stage.find_by_image('discovery')
    stage.color_name?.should_not == "green"
  end

  it ".color_name? discovery should not be blue" do
    stage = Stage.find_by_image('discovery')
    stage.color_name?.should_not == "blue"
  end

  it ".color_name? discovery should not be red" do
    stage = Stage.find_by_image('discovery')
    stage.color_name?.should_not == "red"
  end

  it ".color_name? discovery should not be teal" do
    stage = Stage.find_by_image('discovery')
    stage.color_name?.should_not == "teal"
  end

    #Design
  it ".color_name? design should be red" do
    stage = Stage.find_by_image('design')
    stage.color_name?.should == "red"
  end

  it ".color_name? design should not be green" do
    stage = Stage.find_by_image('design')
    stage.color_name?.should_not == "green"
  end

  it ".color_name? design should not be blue" do
    stage = Stage.find_by_image('design')
    stage.color_name?.should_not == "blue"
  end

  it ".color_name? design should not be yellow" do
    stage = Stage.find_by_image('design')
    stage.color_name?.should_not == "yellow"
  end

  it ".color_name? design should not be teal" do
    stage = Stage.find_by_image('design')
    stage.color_name?.should_not == "teal"
  end

      #Build
  it ".color_name? build should be teal" do
    stage = Stage.find_by_image('build')
    stage.color_name?.should == "teal"
  end

  it ".color_name? build should not be green" do
    stage = Stage.find_by_image('build')
    stage.color_name?.should_not == "green"
  end

  it ".color_name? build should not be blue" do
    stage = Stage.find_by_image('build')
    stage.color_name?.should_not == "blue"
  end

  it ".color_name? build should not be yellow" do
    stage = Stage.find_by_image('build')
    stage.color_name?.should_not == "yellow"
  end

  it ".color_name? build should not be red" do
    stage = Stage.find_by_image('build')
    stage.color_name?.should_not == "red"
  end

  #Default color
  it ".color_name? build should be green by default" do

  end
end

describe Stage, ".before_stage?" do
  include StageSpecHelper
  before(:each) do
    setup_stage_full_environment
  end

  it "should return third stage - one before forth" do
    current_stage = @stages[3]
    Stage.before_stage?(current_stage).should == [@stages[0], @stages[1], @stages[2]]
  end

  it "should return all stages before second stage - just first" do
    current_stage = @stages[1]
    Stage.before_stage?(current_stage).should == [@stages[0]]
  end

  it "should return empty array if first stage" do
    current_stage = @stages.first
    Stage.before_stage?(current_stage).should == []
  end
end

describe Stage, ".after_stage?" do
  include StageSpecHelper
  before(:each) do
    setup_stage_full_environment
  end

  it "should return all stages after third - one 4th and 5th" do
    current_stage = @stages[2]
    Stage.after_stage?(current_stage).should == [@stages[3], @stages[4]]
  end

  it "should return all stages after 4th stage - just first" do
    current_stage = @stages[3]
    Stage.after_stage?(current_stage).should == [@stages[4]]
  end

  it "should return empty array if last stage" do
    current_stage = @stages.last
    Stage.after_stage?(current_stage).should == []
  end
end

describe Stage, ".completed?" do
  include StageSpecHelper
  before(:each) do
    setup_stage_full_environment
  end

  it "should return 4% as completed - 1 response out of 25 questions" do
    stage = @stages.first
    section = stage.survey_sections.first
    FactoryGirl.create(:response, :survey_section_id => section.id, :response_set_id => @idea.response_set.id)
    stage.completed?(@idea).should == 2
  end

  it "should return 0% as completed - 0 response out of 25 questions" do
    stage = @stages.first
    stage.completed?(@idea).should == 0
  end

  it "should return 100% as completed - 30 response out of 25 questions" do
    stage = @stages.first
    section = stage.survey_sections.first
    60.times { FactoryGirl.create(:response, :survey_section_id => section.id, :response_set_id => @idea.response_set.id) }
    stage.completed?(@idea).should == 100
  end
end

describe Stage, ".section related methods" do
  include StageSpecHelper
  before(:each) do
    setup_stage_full_environment
  end

  it "should belong to free section" do
    stage = @stages.first
    section = stage.survey_sections.first
    section.free?.should be_true
  end

  it "should not belong to free section" do
    stage = @stages.second
    section = stage.survey_sections.first
    section.free?.should be_false
  end

  it ".for_startup? should be false if section in first stage" do
    stage = @stages.first
    section = stage.survey_sections.first
    section.for_startup?.should be_false
  end

  it ".for_startup? should be true if section in other than first stage" do
    stage = @stages.second
    section = stage.survey_sections.first
    section.for_startup?.should be_true
  end
end
