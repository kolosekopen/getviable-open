class Idea < ActiveRecord::Base
  extend FriendlyId
  acts_as_paranoid
  acts_as_voteable
  friendly_id :title, use: [:slugged, :history]
  default_scope where("hidden = ?", false)

  has_many :invitations, as: :invitable

  attr_accessible :date_of_birth, :date, :description, :title, :user_id, :response_set_code,
                  :industry_id, :photo, :hidden, :twitter, :facebook, :linkedin
  belongs_to :user
  belongs_to :group
  has_and_belongs_to_many :users

  has_many :activities, :dependent => :destroy
  has_many :expert_requests
  has_one :response_set
  has_one :package

  SURVEY_NAME = ENV['DEFAULT_SURVEY']

  BUSINESS = 1.freeze
  TECHNICAL = 2.freeze
  PRODUCT = 3.freeze

  TYPES = {
    BUSINESS => "Business",
    TECHNICAL => "Technical",
    PRODUCT => "Product"
  }

  belongs_to :industry
  has_attached_file :photo,
                 :styles => {
                   :medium => "150x150>",
                   :small => "100x100>",
                   :box => "60x60>",
                   :square => "50x50>",
                   :micro => "32x32>"
                  },
                  :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml",
                 :default_url => "/images/no_logo_:style.png"

  after_create :assign_package!

  #FRONT SIDE VALIDATIONS USUALLY DON'T WORK IF SOME VALIDATIONS ARE NOT WRITTEN CORRECTLY
  validates_attachment_size :photo, :less_than => 5.megabyte
  validates_attachment_content_type :photo, :content_type => [/image\/jpg/, /image\/jpeg/, /image\/pjpeg/, /image\/png/, /image\/x-png/]

  validates :title, :presence => true
  validates :title, :uniqueness => true
  validates :description, :presence => true

  #Scope for ideas with teams = Startups
  #Scope for ideas without team = Idea
  scope :startups, where(:startup => true)
  scope :only_ideas, where(:startup => false)
  scope :featured, where(:featured => true)
  after_create :add_owner_to_team

  def add_owner_to_team
    IdeasUsers.create(:user_id => self.user_id, :idea_id => self.id, :role_id => 1)
    NotificationWorker.new_idea(self)
  end

  def self.survey_code?
    SURVEY_NAME || ''
  end

  def is_owner?(entity)
    self.user == entity
  end

  def startup!
    self.startup = true
    save!
  end

  def startup?
    self.startup
  end

  def last_activity
    self.activities.order('updated_at DESC').first
  end

  def featured!
    self.featured = true
    self.featured_on = DateTime.now
    save!
  end

  def featured?
    self.featured == true
  end

  #Todo: Refactor this code
  # Find most active ideas in last 48h, which has most activities
  def self.most_active?(no_elements = 4, group_id = nil)
    ideas = Idea.where(:group_id => group_id)
    activities = Activity.where("updated_at > ? AND idea_id IN (?)", DateTime.now - 2.days, ideas.map(&:id)).group_by {|d| d[:idea_id] }
      ideas = {}
      activities.each do |activity|
        idea = Idea.find activity.first
        ideas[idea] = activity.second.count if idea.startup?
      end
      if ideas.count < no_elements
        activities = Activity.where("updated_at > ? AND updated_at < ?", DateTime.now - 90.days,  DateTime.now - 2.days).group_by {|d| d[:idea_id] }
        activities.each do |activity|
          idea = Idea.find activity.first
          ideas[idea] = activity.second.count if idea.startup?
        end
      end

      active = []
      ideas.sort{ |a, b| b.second <=> a.second }.each{|idea| active << idea.first}
      active.first(no_elements)
  end

  def self.find_by_slug(term)
    super || raise(ActiveRecord::RecordNotFound)
  end

  def self.find_by_id(term)
    super || raise(ActiveRecord::RecordNotFound)
  end
  ### Team member related methods ###
  def add_member(entity, role_id = IdeasUsers::MENTOR)
    return false if self.users.include?(entity)
    IdeasUsers.create(:user_id => entity.id, :idea_id => self.id, :role_id => role_id)
    NotificationWorker.added_member(entity, self)
  end

  def remove_member(entity)
    self.users.delete(entity)
  end

  def public?(user)
    member = IdeasUsers.where(:idea_id => self.id, :user_id => user.id).first
    if member.nil? || member.public?
      return true
    else
      return false
    end
  end

  def private?(user)
    member = IdeasUsers.where(:idea_id => self.id, :user_id => user.id).first
    if !member.nil? && member.private?
      return true
    else
      return false
    end
  end

  def member?(user)
    self.users.include?(user)
  end

  def can_ask_expert?
    package.platinum? ? true : expert_requests.count < Package::EXPERT_GUIDANCE_LIMIT[package.package]
    true #TODO: Added for now, so ask expert is visible for everyone.
  end

  private

    def assign_package!
      create_package
    end
end
