class Industry < ActiveRecord::Base
  attr_accessible :title
  has_many :ideas
  
  def self.ordered_industries
    self.order("title")
  end
end
