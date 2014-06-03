class Users::IdeasController < ApplicationController
	before_filter :get_idea, :only => [:startup_idea]
	
	def startup_idea
		if @idea.startup!
			respond_to do |format|
				format.html { redirect_to root_path, notice: 'Idea has became a startup!' }
				format.js
			end
		else
			respond_to do |format|
				format.html { redirect_to root_path }
				format.js
			end
		end
	end

	private

		def get_idea
			@idea = params[:idea_id].to_i != 0 ? Idea.find(params[:idea_id]) : nil
		end
end