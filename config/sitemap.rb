Sitemap::Generator.instance.load :host => "getviable.com" do

  # Sample path:
  #   path :faq
  # The specified path must exist in your routes file (usually specified through :as).

  # Sample path with params:
  #   path :faq, :params => { :format => "html", :filter => "recent" }
  # Depending on the route, the resolved url could be http://mywebsite.com/frequent-questions.html?filter=recent.

  # Sample resource:
  #   resources :articles

  # Sample resource with custom objects:
  #   resources :articles, :objects => proc { Article.published }

  # Sample resource with search options:
  #   resources :articles, :priority => 0.8, :change_frequency => "monthly"

  # Sample resource with block options:
  #   resources :activities,
  #             :skip_index => true,
  #             :updated_at => proc { |activity| activity.published_at.strftime("%Y-%m-%d") }
  #             :params => { :subdomain => proc { |activity| activity.location } }

  path :root, :priority => 1
  path :newest, :priority => 0.5, :change_frequency => "daily"
  path :active, :priority => 0.5, :change_frequency => "daily"
  path :featured, :priority => 0.5, :change_frequency => "daily"

  path :pricing, :priority => 0.2, :change_frequency => "weekly"
  path :contact, :priority => 0.2, :change_frequency => "weekly"
  path :about, :priority => 0.2, :change_frequency => "weekly"

  path :privacy, :priority => 0.1, :change_frequency => "monthly"
  path :terms, :priority => 0.1, :change_frequency => "monthly"

  literal "/" #helpful for vanity urls layering search results

  resources :active, :objects => proc { Idea.featured.where(:group_id => nil).order('featured_on DESC').limit(4) }
  resources :newest, :objects => proc { Idea.startups.where(:group_id => nil).order('created_at DESC').limit(4) }
  # resources :featured, :objects => proc { Idea.most_active? }

  # resources :activities, :params => { :format => "html" }
  # resources :articles, :objects => proc { Article.published }
end
