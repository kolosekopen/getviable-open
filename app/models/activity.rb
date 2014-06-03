class Activity < ActiveRecord::Base
  acts_as_commentable
  attr_accessible :content, :event_type, :idea_id, :survey_section_id

  STATUS_ADDED  = 10.freeze
  STATUS_UPDATED = 20.freeze
  STATUS_COMPLETED = 30.freeze
  STATUS_DELETED  = 40.freeze

  STATUSES = {
    STATUS_ADDED  => "added",
    STATUS_UPDATED => "updated",
    STATUS_COMPLETED => "completed",
    STATUS_DELETED  => "deleted"
  }

  belongs_to :idea, :touch => true
  belongs_to :survey_section

  validates_presence_of :content, :event_type, :idea_id, :survey_section_id

  def self.status_added
  	STATUS_ADDED
  end

  def self.status_updated
  	STATUS_UPDATED
  end

  def self.status_completed
  	STATUS_COMPLETED
  end

  def self.status_deleted
  	STATUS_DELETED
  end

  #TODO: Bevare of XSS attacks!!! Refactor this part
  def content?
    self.content.gsub(/\n/, '<br/>').html_safe
  end

  #TODO: Return to which stage activity belongs to
  def stage?
    self.survey_section.stage?
  end

  def status?
    STATUSES[self.event_type] || "updated"
  end

  def not_recently_updated?
    self.updated_at < (DateTime.now - 10.minutes)
  end

  def self.by_idea?(idea_id)
    self.where(:idea_id => idea_id).order("updated_at DESC").group_by {|d| d[:survey_section_id] }
  end

  # Strip HTML from Activity content
  def stripped_content
    self.content.gsub("</b>", "").gsub("<b>", "")
  end
end
