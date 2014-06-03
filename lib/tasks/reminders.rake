namespace :ideas do

  task :no_idea => :environment do
    User.all.each do |user|
      ideas = user.ideas
      if ideas.empty? && user.created_at < 2.weeks.ago
        reminder = Reminder.where("reminder_for_id = ? AND reminder_for_type = ? AND reminder_type = ?", user.id, user.class.to_s, Reminder::NO_IDEA).first
        if reminder.nil?
          NotificationWorker.no_idea_added(user)
          Reminder.create!(reminder_for: user, reminder_type: Reminder::NO_IDEA)
        elsif !reminder.nil? && reminder.created_at < 2.weeks.ago
          reminder.destroy
          NotificationWorker.no_idea_added(user)
          Reminder.create!(reminder_for: user, reminder_type: Reminder::NO_IDEA)
        end
      elsif !ideas.empty?
        no_new = true
        ideas.each do |idea|
          if idea.created_at > 2.weeks.ago
            no_new = false          
          end
        end
        reminder = Reminder.where("reminder_for_id = ? AND reminder_for_type = ? AND reminder_type = ?", user.id, user.class.to_s, Reminder::NO_IDEA).first
        if reminder.nil? && no_new
          NotificationWorker.no_idea_added(user)
          Reminder.create!(reminder_for: user, reminder_type: Reminder::NO_IDEA)
        elsif !reminder.nil? && no_new
          if reminder.created_at < 2.weeks.ago
            reminder.destroy
            NotificationWorker.no_idea_added(user)
            Reminder.create!(reminder_for: user, reminder_type: Reminder::NO_IDEA)
          end
        end
      end
    end
  end

  task :no_idea_activity => :environment do
    User.all.each do |user|
      ideas = user.ideas.where("updated_at < ?", 1.week.ago)
      ideas.each do |idea|
        reminder = Reminder.where("reminder_for_id = ? AND reminder_for_type = ? AND reminder_type = ?", idea.id, idea.class.to_s, Reminder::NO_IDEA_ACTIVITY).first
        if reminder.nil?
          NotificationWorker.no_activity(user, idea)
          Reminder.create!(reminder_for: idea, reminder_type: Reminder::NO_IDEA_ACTIVITY)
        elsif reminder.created_at < 1.week.ago
          reminder.destroy
          NotificationWorker.no_activity(user, idea)
          Reminder.create!(reminder_for: idea, reminder_type: Reminder::NO_IDEA_ACTIVITY)
        end
      end
    end
  end

  task :no_member_added => :environment do
    User.all.each do |user|
      ideas = user.ideas
      ideas.each do |idea|
        if (idea.users.to_a.reject{ |e| [user].include? e }).empty? && idea.created_at < 2.weeks.ago
          reminder = Reminder.where("reminder_for_id = ? AND reminder_for_type = ? AND reminder_type = ?", idea.id, idea.class.to_s, Reminder::NO_MEMBER_ADDED).first
          if reminder.nil?
            NotificationWorker.no_member_added(user, idea)
            Reminder.create!(reminder_for: idea, reminder_type: Reminder::NO_MEMBER_ADDED)
          elsif reminder.created_at < 2.week.ago
            reminder.destroy
            NotificationWorker.no_member_added(user, idea)
            Reminder.create!(reminder_for: idea, reminder_type: Reminder::NO_MEMBER_ADDED)
          end
        end
      end
    end
  end

  def pick(model_class)
  end
end