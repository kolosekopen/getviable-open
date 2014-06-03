class CustomEmail < ActiveRecord::Base
  attr_accessible :custom_email, :original_email

  validates :original_email, uniqueness: true
  validates :custom_email, uniqueness: true
  validate :custom_email_additional_uniqueness

  # Relations
  belongs_to :user

  # Callbacks
  before_create :assign_emails!

  def prefered_email
    custom_email
  end

  def original_with_custom
    @original_with_custom ||= CustomEmail.where(original_email: custom_email)
  end

  def custom_email_available?
    original_with_custom.empty? || original_with_custom.first.id == id
  end

  private

    def custom_email_additional_uniqueness
      unless custom_email_available?
        # errors.add(:custom_email, "This email address is already in use on another account. If this should not be the case, please contact us for assistance.")
        errors.add(:custom_email, "ThThere was a problem with updating your email, please contact us for assistance.")
      end
    end

    def assign_emails!
      self.original_email = user.email
      self.custom_email = user.email
    end
end
