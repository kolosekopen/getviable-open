class DependencyCondition < ActiveRecord::Base
  unloadable
  include Surveyor::Models::DependencyConditionMethods

  def custom_unparse(dsl)
    attrs = (self.attributes.diff Dependency.new.attributes).delete_if{|k,v| %w(created_at updated_at question_id question_group_id rule_key rule operator id dependency_id answer_id).include? k}.symbolize_keys!
    dsl << "  " if dependency.question.part_of_group?
    dsl << "    condition"
    dsl << "_#{rule_key}" unless rule_key.blank?
    dsl << " :q_#{question.reference_identifier}, \"#{operator}\""
    dsl << (attrs.blank? ? ", {:answer_reference=>\"#{answer && answer.reference_identifier}\"}\n" : ", {#{attrs.inspect.gsub(/\{|\}/, "")}, :answer_reference=>\"#{answer && answer.reference_identifier}\"}\n")
  end  

end
