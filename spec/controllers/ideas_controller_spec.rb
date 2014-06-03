require 'spec_helper'

describe IdeasController do
  let(:idea) { mock_model(Idea, :title => "IdeaTitle") }
  let(:activity) { mock_model(Activity) }

  def valid_attributes
    { "title" => "MyString", "description" => "MyDescription" }
  end

  it_should_require_signed_in_user_for_actions :show, :edit, :update, :destroy

  context "As logged in user" do
    login_user

    describe "GET index" do

      it "assigns all ideas as @ideas" do
        subject.current_user.stub_chain(:ideas, :where).and_return([idea])
        subject.current_user.stub_chain(:ideas, :startups).and_return([idea, idea])

        get :index
        assigns(:ideas).should eq([idea])
      end

      it "assigns all startups as @startups" do
        subject.current_user.stub_chain(:ideas, :where).and_return([idea])
        subject.current_user.stub_chain(:ideas, :startups).and_return([idea, idea])

        get :index
        assigns(:startups).should eq([idea, idea])
      end
    end

    describe "GET 'show'" do

      before do
        Idea.should_receive(:find_by_slug).and_return(idea)
        Activity.should_receive(:by_idea?).and_return([activity])
      end

      it "assigns requested idea as @idea" do
        get 'show', :id => idea.title

        assigns[:idea].should eql(idea)
      end

      it "assigns activities based on idea" do
        get 'show', :id => idea.title

        assigns[:activities].should eql([activity])
      end

      it "renders 'show' template" do
        get 'show', :id => idea.title

        response.should render_template("show")
      end

    end

    describe "GET new" do
      it "assigns a new idea as @idea" do
        get :new, {}
        assigns(:idea).should be_a_new(Idea)
      end
    end


  end

  context "As not logged in user" do
    describe "GET index" do

      it "assigns all ideas as @ideas" do
        get :index
        assigns(:ideas).should eq(nil)
      end

      it "assigns all startups as @startups" do
        get :index
        assigns(:startups).should eq(nil)
      end
    end
  end

  pending "Add edit action"
  pending "Add create action"
  pending "Add update action"
  pending "Add destroy action"
end
