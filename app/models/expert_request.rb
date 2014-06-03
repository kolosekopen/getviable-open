class ExpertRequest < ActiveRecord::Base
  attr_accessible :problem, :subject, :terms_conditions, :support_type, :idea_id, :survey_section_id
  has_one :order
  belongs_to :user
  belongs_to :idea


  IDEA_GOOD = 10.freeze
  CURRENT_COMPETITION = 20.freeze
  FUTURE_COMPETITION = 30.freeze
  OPTIONS_REVENUE = 40.freeze
  DOMAIN_CHOICE = 50.freeze
  COMPETITIVE = 60.freeze
  CUSTOMER_PERSONAS = 70.freeze
  CUSTOMER_NEEDS = 80.freeze
  IDEA_VALIDATION = 90.freeze
  MVP = 100.freeze
  OTHER = 110.freeze

  SERVICES = {
    IDEA_GOOD => "How do I know if my idea is any good?",
    CURRENT_COMPETITION => "I don't have a technical co-founder. Help me build my idea.",
    FUTURE_COMPETITION => "Help me find a name.",
    OPTIONS_REVENUE => "Help me with wireframes.",
    DOMAIN_CHOICE => "Help me find a mentor.",
    COMPETITIVE => "Help me design my app or website.",
    CUSTOMER_PERSONAS => "Help me choose technology.",
    CUSTOMER_NEEDS => "Help me find an outsource partner to build my idea.",
    IDEA_VALIDATION => "Help me build my mobile app.",
    OTHER => "Other (specify below)"
  }

  before_create :generate_token

  after_create :send_request

  def send_request
    UserMailer.expert_request_summary(self).deliver
  end

  protected

  def generate_token
    self.code = loop do
      random_code = SecureRandom.urlsafe_base64
      break random_code unless ExpertRequest.where(code: random_code).exists?
    end
  end
end
