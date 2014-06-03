class Promo < ActiveRecord::Base
  attr_accessible :code, :discount, :expires, :used

  scope :with_code, ->(code) { where(code: code) }

  # TEST PROMO
  # $ be rails c
  # > Promo.create! code: '0b6db4498c710352a6420fdc77eca2be', discount: 10, expires: Time.now + 1.hour, used: false

  def self.get_with_code(code)
  	with_code(code).try :first
  end

  def expired?
  	expires < Time.zone.now
  end

  def valid_promo?
  	!expired?# and !used
  end

  def used!
    self.used = true
    save!
  end
end
