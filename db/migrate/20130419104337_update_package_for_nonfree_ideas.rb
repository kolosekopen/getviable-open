class UpdatePackageForNonfreeIdeas < ActiveRecord::Migration
  def change
  	Idea.all.each do |idea|
      dups = Idea.where(:title => idea.title)
      if dups.size > 1
        dups.each_with_index do |item, index|
          if index > 0
            item.update_attributes(:title => idea.title + ('.' * index))
          end
        end
      end

  		if Stage.all[1].completed?(idea) > 0 || Stage.all[2].completed?(idea) > 0 || Stage.all[3].completed?(idea) > 0 || Stage.all[4].completed?(idea) > 0
        idea.package.reserve!(Package::SILVER)
        idea.package.paid!
      end
  	end
  end
end
