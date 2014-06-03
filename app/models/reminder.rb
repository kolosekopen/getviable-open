class Reminder < ActiveRecord::Base

  NO_IDEA          = 1
  NO_IDEA_ACTIVITY = 2
  NO_MEMBER_ADDED  = 3

  attr_accessible :reminder_type, :reminder_for_id, :reminder_for_type, :reminder_for

  belongs_to :reminder_for, :polymorphic => true
end
