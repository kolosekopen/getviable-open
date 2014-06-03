class Stage < ActiveRecord::Base
  attr_accessible :color, :description, :title, :image, :icon, :order

  has_attached_file :icon,
                 :styles => {
                   :medium => "30x30",
                  },
                  :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml",
                 :default_url => "/images/no_stage_icon_:style.png"


  has_many :survey_sections

  scope :for_idea, lambda { |idea|
                            joins("RIGHT JOIN survey_sections ON stages.id = survey_sections.stage_id")
                           .where("survey_sections.survey_id = ?", idea.response_set.survey.id)
                           .group("stages.id")
                          }
  scope :before_stage?, lambda {|stage| where("stages.order < ? ", stage.order).order("stages.order ASC")}
  scope :after_stage?, lambda {|stage| where("stages.order > ? ", stage.order).order("stages.order ASC")}


  #TODO: Refactor as it's more like brute force
  def completed?(idea)
    questions_count, responses_count = 0, 0
    self.survey_sections.each do |section|
      questions_count += section.questions.count
      responses = Response.where(:survey_section_id => section.id, :response_set_id => idea.response_set.try(:id))
      responses_count += responses.count
    end
    if responses_count == 0
      0
    else
      finished_percentage = ((responses_count)*100/(questions_count))
      finished_percentage = 100 if finished_percentage > 100
      finished_percentage
    end
  end

  def color_name?
    case self.image
    when "clarify"
      "green"
    when "target"
      "blue"
    when "discovery"
      "yellow"
    when "design"
      "red"
    when "build"
      "teal"
    else
      "green"
    end
  end
end
