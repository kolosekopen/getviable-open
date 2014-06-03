class AssignPackageToIdeas < ActiveRecord::Migration
  def change
  	Idea.all.each do |idea|
      idea.package.nil? ? idea.send(:assign_package!) : nil
  	end
  end
end
