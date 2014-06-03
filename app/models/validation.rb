class Validation < ActiveRecord::Base
  unloadable
  include Surveyor::Models::ValidationMethods

  def custom_unparse(dsl)
    attrs = (self.attributes.diff Validation.new.attributes).delete_if{|k,v| %w(created_at updated_at id answer_id).include?(k) }.symbolize_keys!
    dsl << "  " if answer.question.part_of_group?
    dsl << "    validation"
    dsl << (attrs.blank? ? "\n" : " #{attrs.inspect.gsub(/\{|\}/, "")}\n")
    validation_conditions.each{|validation_condition| validation_condition.custom_unparse(dsl)}
  end
end
