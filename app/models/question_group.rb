class QuestionGroup < ActiveRecord::Base
  unloadable
  include Surveyor::Models::QuestionGroupMethods

  def title
    return id.to_s + " - " + text.truncate(50)
  end

  def short_title
    return id.to_s + " - " + text.truncate(50)
  end

  def custom_unparse(dsl)
    attrs = (self.attributes.diff QuestionGroup.new(:text => text).attributes).delete_if{|k,v| %w(created_at updated_at id api_id).include?(k) or (k == "display_type" && %w(grid repeater default).include?(v))}.symbolize_keys!
    method = (%w(grid repeater).include?(display_type) ? display_type : "group")
    dsl << "\n"
    dsl << "    #{method} \"#{text}\""
    dsl << (attrs.blank? ? " do\n" : ", #{attrs.inspect.gsub(/\{|\}/, "")} do\n")
    questions.first.answers.each{|answer| answer.custom_unparse(dsl)} if display_type == "grid"
    questions.each{|question| question.custom_unparse(dsl)}
    dsl << "    end\n"
  end

end