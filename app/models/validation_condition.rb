class ValidationCondition < ActiveRecord::Base
  unloadable
  include Surveyor::Models::ValidationConditionMethods

  def custom_unparse(dsl)
    attrs = (self.attributes.diff ValidationCondition.new.attributes).delete_if{|k,v| %w(created_at updated_at operator rule_key id validation_id).include? k}.symbolize_keys!
    dsl << "  " if validation.answer.question.part_of_group?
    dsl << "    condition"
    dsl << "_#{rule_key}" unless rule_key.blank?
    dsl << " \"#{operator}\""
    dsl << (attrs.blank? ? "\n" : ", #{attrs.inspect.gsub(/\{|\}/, "")}\n")
  end
end
