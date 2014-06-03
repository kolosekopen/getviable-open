class NotificationWorker < ActionMailer::Base
  require 'mandrill'
  include Sidekiq::Worker
  default :from => "\"GetViable\" <no-reply@getviable.com>"
  #On signup - Welcome. Done
  #New Idea added - Get started. Done
  #added team member - welcome to team member. Done
  

  def new_idea(idea)
    begin
      m = Mandrill::API.new
      template = m.templates.render 'GetViable New Idea Added', [{:name => "first_name", :content => idea.user.name}, {:name => "idea_name", :content => idea.title}]
      mail_job = mail(:to => idea.user.email, :subject => "Getting started with #{idea.title}") do |format|
         format.html { template['html'] }
         #format.text { render "test" }
      end
      mail_job.deliver
    rescue Exception => e

    end
  end

  def welcome_email(user)
      begin
        m = Mandrill::API.new
        template = m.templates.render 'GetViable Welcome', [{:name => "first_name", :content => user.name}]
        mail_job = mail(:to => user.email, :subject => "Welcome to GetViable") do |format|
           format.html { template['html'] }
           #format.text { render "test" }
        end
        mail_job.deliver
      rescue Exception => e
        
      end
      
      #mail_job.deliver
  end

  def added_member(user, idea)
    begin
      m = Mandrill::API.new
      template = m.templates.render 'GetViable New Team Member', [{:name => "first_name", :content => user.name}, {:name => "idea_name", :content => idea.title}]
      mail_job = mail(:to => user.email, :subject => "Invitation from #{idea.user.name} to join my idea, #{idea.title}") do |format|
         format.html { template['html'] }
         #format.text { render "test" }
      end
      mail_job.deliver
    rescue Exception => e
     
    end
  end

  #two weeks no idea added - Add idea - Done
  #One week no activity on idea - keep going. Done
  #two weeks no team member added - Invite a team member. Done

  def no_idea_added(user)
    begin
      m = Mandrill::API.new
      template = m.templates.render 'GetViable 2 weeks no idea added', [{:name => "first_name", :content => user.name}]
      mail_job = mail(:to => user.email, :subject => "Remember to add your idea and get started") do |format|
         format.html { template['html'] }
         #format.text { render "test" }
      end
      mail_job.deliver
    rescue Exception => e
     
    end
  end

  def no_activity(user, idea)
    begin
      m = Mandrill::API.new
      template = m.templates.render 'GetViable 1 week No Activity', [{:name => "first_name", :content => user.name}, {:name => "idea_name", :content => idea.title}]
      mail_job = mail(:to => user.email, :subject => "#{idea.title} is beginning! Keep going...") do |format|
         format.html { template['html'] }
         #format.text { render "test" }
      end
      mail_job.deliver
    rescue Exception => e
     
    end
  end

  def no_member_added(user, idea)
    begin
      m = Mandrill::API.new
      template = m.templates.render 'GetViable Add Team member', [{:name => "first_name", :content => user.name}, {:name => "idea_name", :content => idea.title}]
      mail_job = mail(:to => user.email, :subject => "#{idea.title} is beginning! Time to grow your team.") do |format|
         format.html { template['html'] }
         #format.text { render "test" }
      end
      mail_job.deliver
    rescue Exception => e
     
    end
  end



end