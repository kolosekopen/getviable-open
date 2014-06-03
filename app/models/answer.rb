class Answer < ActiveRecord::Base
  unloadable
  include Surveyor::Models::AnswerMethods

  def title
    return display_order.to_s + " - " + reference_identifier.to_s + " - " + text.truncate(50)
  end

  def short_title
    return display_order.to_s + " - " + reference_identifier.to_s + " - " + text.truncate(50)
  end

  def custom_unparse(dsl)
    attrs = (self.attributes.diff Answer.new(:text => text).attributes).delete_if{|k,v| %w(created_at updated_at reference_identifier response_class id question_id api_id).include? k}.symbolize_keys!
    attrs.delete(:is_exclusive) if text == "Omit" && is_exclusive == true
    attrs.merge!({:is_exclusive => false}) if text == "Omit" && is_exclusive == false
    dsl << "  " if question.part_of_group?
    dsl << "    a"
    dsl << "_#{reference_identifier}" unless reference_identifier.blank?
    if response_class.to_s.titlecase == text && attrs == {:display_type => "hidden_label"}
      dsl << " :#{response_class}"
    else    
      dsl << [ text.blank? ? nil : text == "Other" ? " :other" : text == "Omit" ? " :omit" : " \"#{text.gsub(/\"/,"\\\"")}\"",
                (response_class.blank? or response_class == "answer") ? nil : " #{response_class.to_sym.inspect}",
                attrs.blank? ? nil : " #{attrs.inspect.gsub(/\{|\}/, "")}\n"].compact.join(",")
    end
    dsl << "\n"
    validations.each{|validation| validation.custom_unparse(dsl)}
  end
end
