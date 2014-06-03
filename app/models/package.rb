class Package < ActiveRecord::Base
  attr_accessible :code, :idea_id, :package, :paid, :promo_code
  has_paper_trail
  
  belongs_to :idea
  has_many :orders

  before_create :generate_token
  after_create :set_free_package!

  # Startup packages
  FREE      = 0
  SILVER    = 1
  GOLD      = 2
  PLATINUM  = 3

  PACKAGES  = {
    FREE      => "free",
    SILVER    => "startup",
    GOLD      => "gold",
    PLATINUM  => "platinum"
  }

   if ENV['PAYMENTS'] == 'test'
    PRICE = {
      FREE      => 0,
      SILVER    => 1,
      GOLD      => 2,
      PLATINUM  => 3
    }
   else
    PRICE = {
      FREE      => 0,
      SILVER    => 99,
      GOLD      => 499,
      PLATINUM  => 999
    }
  end

  EXPERT_GUIDANCE_LIMIT = {
    FREE      => 0,   # no questions allowed
    SILVER    => 0,   # no questions allowed
    GOLD      => 2,   # limited number of questions allowed
    PLATINUM  => -1   # unlimited number of questions allowed
  }

  def name
    PACKAGES[package].capitalize
  end

  # TODO: make sure to disable upgrading to lower price for all packages
  def set_free_package!
    self.package = FREE
    save!
  end

  def set_silver_package!
    self.package = SILVER
    save!
  end

  def set_gold_package!
    self.package = GOLD
    save!
  end

  def set_platinum_package!
    self.package = PLATINUM
    save!
  end

  def set_package!(new_package)
    self.package = new_package
    save!
  end

  def free?
    return true if Setting.payments_enabled == 'false'
    package == FREE
  end

  def silver?
    package == SILVER
  end

  def gold?
    package == GOLD
  end

  def platinum?
    #package == PLATINUM
    silver?
  end

  # Calculate upgrade package price

  def silver_upgrade_price
    upgrade_price(SILVER)
  end

  def gold_upgrade_price
    upgrade_price(GOLD)
  end

  def platinum_upgrade_price
    upgrade_price(PLATINUM)
  end

  def upgrade_price(new_package)    
    promo_code? ? promo_upgrade_price(new_package) : regular_upgrade_price(new_package)
  end

  def regular_price(new_package)
    regular_upgrade_price(new_package)
  end

  def reserved_upgrade_price
    reserved_package.nil? ? 0 : upgrade_price(reserved_package)
  end

  def reserve!(package)
    self.paid = false
    self.reserved_package = package
    promo.used! if promo
    save!
  end

  def paid!
    self.paid = true
    set_package!(reserved_package)
    self.reserved_package = nil
    self.idea.startup!
    save!    
  end

  def use_promo!(promo_code)
    promo = Promo.get_with_code(promo_code)
    if promo && promo.valid_promo?
      self.promo_code = promo_code
      save!
    end
  end

  def promo
    @promo ||= Promo.get_with_code(promo_code)
  end

  protected

    def generate_token
      self.code = loop do
        random_code = SecureRandom.urlsafe_base64
        break random_code unless ExpertRequest.where(code: random_code).exists?
      end
    end

    def calculate_upgrade_price_for(choosen_package)
      free? ? PRICE[choosen_package] : PRICE[choosen_package] - PRICE[package]
    end

    def calculate_promo_upgrade_price_for(choosen_package, discount)
      without_discount = calculate_upgrade_price_for(choosen_package)
      (without_discount - (without_discount * discount / 100)).round
    end

    def regular_upgrade_price(new_package)
      package >= new_package ? PRICE[FREE] : calculate_upgrade_price_for(new_package)
    end

    def promo_upgrade_price(new_package)
      if promo and !promo.expired?
        package >= new_package ? PRICE[FREE] : calculate_promo_upgrade_price_for(new_package, promo.discount)
      else
        regular_upgrade_price(new_package)
      end
    end
end
