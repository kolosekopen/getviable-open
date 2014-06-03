class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable#, :validatable
  devise :omniauthable

  # EXPERIENCE_ENTERPRENEUR = 10.freeze
  # EXPERIENCE_ADVISOR  = 20.freeze
  # EXPERIENCE_MENTOR = 30.freeze

  # EXPERIENCES = {
  #   EXPERIENCE_ENTERPRENEUR => 'entrepreneur',
  #   EXPERIENCE_ADVISOR  => 'advisor',
  #   EXPERIENCE_MENTOR => 'mentor'
  # }

  has_attached_file :photo,
                 :styles => {
                   :medium => "150x150>",
                   :small => "100x100>",
                   :square => "50x50>"
                  },
                  :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml",
                 :default_url => "/images/profile-coming-soon.png"#,
                 #:path => ":rails_root/public/system/users/images/:id/:style/:filename",
                 #:url => "/system/users/images/:id/:style/:filename"
  validates_attachment_size :photo, :less_than => 5.megabyte
  validates_attachment_content_type :photo, :content_type => /image\//
  #validates :email,
  #        :presence => true,
  #        :uniqueness => {:case_sensitive => false, :message => "This email address is already in use on another account. If this is should not be the case, please [contact us] for assistance." }

  #validates_inclusion_of :experience, :in => [EXPERIENCE_ENTERPRENEUR, EXPERIENCE_ADVISOR, EXPERIENCE_MENTOR],
                         #:message => " must be in #{EXPERIENCES.values.join ', '}"

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :nickname, :password, :password_confirmation, :remember_me, :provider, :name, :first_name, :last_name
  attr_accessible :user_id, :location, :verified, :gender, :image, :photo, :description, :uid, :website, :blog
  attr_accessible :invitation_idea_id, :invitee_role_id, :custom_email_attributes, :updates_notifications, :comments_notifications
  attr_accessible :registration_invitation_id

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :ideas
  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :ideas
  has_one :person
  has_many :comments
  has_many :expert_requests
  has_one :custom_email

  belongs_to :registration_invitation

  accepts_nested_attributes_for :custom_email
  acts_as_voter

  # Callbacks
  after_create :create_custom_email, :deactivate_invitation, :welcome_email

  def welcome_email
    NotificationWorker.welcome_email(self)
  end

  def deactivate_invitation
    registration_invitation.update_attribute(:active, false) unless registration_invitation.nil?
  end

  def to_param
    [id, name.try(:parameterize)].join("-")
  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s)
  end

  def idea_role?(idea)
    relation = IdeasUsers.where(:user_id => self.id, :idea_id => idea.id).first
    IdeasUsers::TYPES[relation.role_id]
  end

  def make_admin
    self.roles << Role.admin
  end

  def revoke_admin
    self.roles.delete(Role.admin)
  end

  def add_to_group(group)
    self.groups << group
  end

  def remove_from_group(group)
    self.groups.delete(group)
  end

  def admin?
    role?(:admin)
  end

  #If user doesn't have role, than it means it's just a regular user
  def has_role?
    !self.roles.empty?
  end

#   {
#   :provider => 'facebook',
#   :uid => '1234567',
#   :info => {
#     :nickname => 'jbloggs',
#     :email => 'joe@bloggs.com',
#     :name => 'Joe Bloggs',
#     :first_name => 'Joe',
#     :last_name => 'Bloggs',
#     :image => 'http://graph.facebook.com/1234567/picture?type=square',
#     :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
#     :location => 'Palo Alto, California',
#     :verified => true
#   },
#   :credentials => {
#     :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
#     :expires_at => 1321747205, # when the access token expires (it always will)
#     :expires => true # this will always be true
#   },
#   :extra => {
#     :raw_info => {
#       :id => '1234567',
#       :name => 'Joe Bloggs',
#       :first_name => 'Joe',
#       :last_name => 'Bloggs',
#       :link => 'http://www.facebook.com/jbloggs',
#       :username => 'jbloggs',
#       :location => { :id => '123456789', :name => 'Palo Alto, California' },
#       :gender => 'male',
#       :email => 'joe@bloggs.com',
#       :timezone => -8,
#       :locale => 'en_US',
#       :verified => true,
#       :updated_time => '2011-11-11T06:21:03+0000'
#     }
#   }
# }

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    info = access_token['info']
    raw = access_token['extra']['raw_info']
    uid = access_token.uid
    if user = User.find_by_email_and_provider(info["email"], "facebook")
      user
    else # Create a user with a stub password.
      User.create(:email => info["email"], :password => Devise.friendly_token[0,20], :name => info.name,
                   :location => info.location, :image => info.image, :first_name => raw.first_name, :last_name => raw.last_name,
                   :verified => raw.verified, :gender => raw.gender, :provider => access_token['provider'], :uid => uid)
    end
  end


  #TODO: Task that will update all twitter images from normal to bigger
  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token['info']
    uid = access_token.uid
    if user = User.find_by_nickname(data["nickname"])
      user
    else # Create a user with a stub password.
      image = data['image'].gsub('normal', 'bigger')
      User.create(:nickname => data["nickname"], :name => data['name'], :email => data["nickname"] + '@twitter.com', :password => Devise.friendly_token[0,20], :provider => access_token['provider'],
                   :location => data["location"], :image => image, :uid => uid)
    end
  end

  #Later on switch everything to this method
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
            user.provider = auth.provider
            user.uid = auth.uid
            user.email = auth.info.email
            user.image = auth.info.image
            user.name = auth.info.name
            user.description = auth.info.description
            user.first_name = auth.info.first_name
            user.last_name = auth.info.last_name
            user.location = auth.info.location
            user.password = Devise.friendly_token[0,20]
    end
  end

  def image?
    if !self.photo_file_name.nil?
      self.photo
    else
      self.image.gsub('normal', 'bigger') if self.provider == "twitter"
      self.image || "default-profile.png"
    end
  end

  def is_entity?(other_entity)
    self == other_entity
  end

  def needs_password?
    #self.provider.nil?
    true
  end

  def has_group?
    self.groups.count > 0
  end

  def group?(group_id)
    self.groups.map(&:id).include?(group_id)
  end
end
