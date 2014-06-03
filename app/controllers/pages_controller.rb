class PagesController < ApplicationController
  layout :dynamic_layout

  def index
      @featured = Idea.featured.where(:group_id => nil).order('featured_on DESC').limit(4)
      @newest = Idea.startups.where(:group_id => nil).order('created_at DESC').limit(4)
      @most_active = Idea.most_active?#.where(:group_id => nil)      
  end

  def contact
  	
  end

  def pricing
    
  end

  def terms_conditions
    
  end

  def privacy
    
  end

  def about_us
    
  end

  def featured
    if current_group.nil?
      @featured = Idea.featured.where(:group_id => nil).order('featured_on DESC').limit(16)
    else
      @featured = Idea.featured.order('featured_on DESC').limit(16)
    end
  end

  def active
    @most_active = Idea.most_active?(16)
  end

  def newest
    if current_group.nil?
      @newest = Idea.startups.where(:group_id => nil).order('created_at DESC').limit(16)
    else
      @newest = Idea.startups.order('created_at DESC').limit(16)
    end
  end

end
