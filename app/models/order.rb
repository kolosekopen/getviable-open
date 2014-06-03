class Order < ActiveRecord::Base
  attr_accessible :express_payer_id, :express_token, :first_name, :last_name
  attr_accessible :package_code
  has_many :transactions, :class_name => "OrderTransaction"
  belongs_to :user
  belongs_to :package

  # Store all responses to track problems!
  def purchase
    response = process_purchase
    transactions.create!(:action => "purchase", :amount => package.reserved_upgrade_price, :response => response)
    if response.success?
      package.paid!
      UserMailer.package_summary(package).deliver
    end

    # First part is success (true/false), second error message
    [response.success?, response.params["message"] ]
  end

  def price_in_cents
    (package.reserved_upgrade_price * 100).round
  end

  # Override express_token assignment, and make it smarter
  # Get all data from Paypal connected to token and assign Order information
  def express_token=(token)
    write_attribute(:express_token, token)
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
      self.first_name = details.params["first_name"]
      self.last_name = details.params["last_name"]
    end
  end

  private

  def process_purchase
    unless express_token.blank?
      EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
    end
  end

  def express_purchase_options
    {
      :ip => ip_address,
      :token => express_token,
      :payer_id => express_payer_id
    }
  end

end
