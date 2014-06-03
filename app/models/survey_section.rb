module Surveyor
  module Models
    module SurveySectionMethods
      def self.included(base)
        # Associations
        base.send :has_many, :questions, :order => "display_order ASC", :dependent => :destroy
        base.send :accepts_nested_attributes_for, :questions, :allow_destroy => true
        base.send :attr_accessible, :questions_attributes

        base.send :has_many, :activities
        base.send :belongs_to, :survey
        base.send :belongs_to, :stage


        # Scopes
        base.send :default_scope, :order => "stage_id ASC, display_order ASC"
        base.send :scope, :with_includes, { :include => {:questions => [:answers, :question_group, {:dependency => :dependency_conditions}]}}
        
        @@validations_already_included ||= nil
        unless @@validations_already_included
          # Validations
          base.send :validates_presence_of, :title, :display_order
          # this causes issues with building and saving
          #, :survey
          
          @@validations_already_included = true
        end
        
        # Whitelisting attributes
        base.send :attr_accessible, :survey, :survey_id, :title, :description, :reference_identifier, :data_export_identifier, :common_namespace, :common_identifier, :display_order, :custom_class, :stage_id, :video_url
      end

      # Instance Methods
      def initialize(*args)
        super(*args)
        default_args
      end

      def default_args
        self.data_export_identifier ||= Surveyor::Common.normalize(title)
      end
      
      def questions_and_groups
        qs = []
        questions.each_with_index.map do |q,i|
          if q.part_of_group?
            if (i+1 >= questions.size) or (q.question_group_id != questions[i+1].question_group_id)
              q.question_group
            end
          else
            q
          end
        end.compact
      end
    end
  end
end

class SurveySection < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveySectionMethods

   #TODO: Refactor this metod. Due to speed it's not optimised at all.
   #TODO: Special case when Question label is added - because there is no indicator
  def completed?(idea_id)
    idea = Idea.find idea_id
    questions_count = self.questions.count
    responses = Response.where(:survey_section_id => self.id, :response_set_id => idea.response_set.id)
    responses_count = responses.count
    if responses_count == 0
      0
    else
      finished_percentage = ((responses_count)*100/(questions_count))
      finished_percentage = 100 if finished_percentage > 100
      finished_percentage = 27 if finished_percentage < 27 && finished_percentage > 0
      finished_percentage
    end
  end

  #Check if stage if is larger than given number. Certain stage implys that idea is a startup
  def for_startup?
    self.stage_id > 1
  end

  def stage?
    self.stage
  end

  def free?
    if Setting.payments_enabled == 'true'
      stage = self.stage
      stage.try(:image) == 'clarify'
    else
      true
    end
  end

  def custom_unparse(dsl)
    attrs = (self.attributes.diff SurveySection.new(:title => title).attributes).delete_if{|k,v| %w(created_at updated_at id survey_id).include? k}.symbolize_keys!
    group_questions = []
    dsl << "  section \"#{title}\""
    dsl << (attrs.blank? ? " do\n" : ", #{attrs.inspect.gsub(/\{|\}/, "")} do\n")
    questions.each_with_index do |question, index|
      if question.solo?
        question.custom_unparse(dsl)
      else # gather up the group questions
        group_questions << question
        if (index + 1 >= questions.size) or (question.question_group != questions[index + 1].question_group)
          # this is the last question of the section, or the group
          question.question_group.custom_unparse(dsl)
        end
        group_questions = []
      end
    end
    dsl << "  end\n"
  end
end