class AddOwnersToIeasUsers < ActiveRecord::Migration
  def change
  	ideas = Idea.all
  	ideas.each do |idea|
  		IdeasUsers.create!(:user_id => idea.user_id, :idea_id => idea.id, :role_id => 1)
  	end
  end
end
