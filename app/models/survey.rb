class Survey < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveyMethods

  accepts_nested_attributes_for :sections, :allow_destroy => true
  attr_accessible :sections_attributes

  has_many :questions, :through => :sections

  def test_idea_id?
  	Idea.find_by_slug("test-for-" + self.title).try(:id)
  end

  def custom_unparse(dsl)
    attrs = (self.attributes.diff Survey.new(:title => title).attributes).delete_if{|k,v| %w(created_at updated_at inactive_at id title access_code api_id).include? k}.symbolize_keys!
    dsl << "survey \"#{title}\""
    dsl << (attrs.blank? ? " do\n" : ", #{attrs.inspect.gsub(/\{|\}/, "")} do\n")
    sections.each{|section| section.custom_unparse(dsl)}
    dsl << "end\n"
  end
end