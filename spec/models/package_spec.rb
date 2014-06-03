require 'spec_helper'

module PackageSpecHelper
  def setup_idea_full_environment
    @user = FactoryGirl.create(:user_with_ideas)
    @other_user = FactoryGirl.create(:user)
    @idea = @user.ideas.first
    @package = @idea.package
    5.times{ FactoryGirl.create(:activity, :idea_id => @idea.id) }
  end
end

describe Package, '#can_ask_expert?' do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context 'when free package' do
    it 'should be false' do
      @package.set_free_package!
      @idea.can_ask_expert?.should be_false
    end
  end

  context 'when paid package' do
    context 'when silver package' do
      it 'should be false' do
        @package.set_silver_package!
        @idea.can_ask_expert?.should be_false
      end
    end

    context 'when gold package' do
      it 'should be true' do
        @package.set_gold_package!
        @idea.can_ask_expert?.should be_true
      end
    end

    context 'when platinum package' do
      it 'should be true' do
        @package.set_platinum_package!
        @idea.can_ask_expert?.should be_true
      end
    end
  end
end

describe Package, '#set_free_package!' do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context 'right after create' do
    it 'should have assigned free package' do
      @package.should be_free
    end
  end

  context 'when free package' do
    before { @package.set_free_package! }

    it 'should re-set the package' do
      @package.should be_free
    end
  end

  context 'when paid package' do
    before { @package.set_silver_package! }

    it 'should not be free' do
      @package.should_not be_free
    end

    context 'when set to free' do
      it 'should be free' do
        @package.set_free_package!
        @package.should be_free
      end
    end
  end
end

describe Package, '#set_silver_package!' do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context 'when free package' do
    before { @package.set_free_package! }

    it 'should re-set the package' do
      @package.should_not be_silver
    end
  end

  context 'when silver' do
    before { @package.set_silver_package! }

    it 'should be silver' do
      @package.should be_silver
    end
  end
end

describe Package, '#set_gold_package!' do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context 'when free package' do
    before { @package.set_free_package! }

    it 'should re-set the package' do
      @package.should_not be_gold
    end
  end

  context 'when gold' do
    before { @package.set_gold_package! }

    it 'should be gold' do
      @package.should be_gold
    end
  end
end

describe Package, '#set_platinum_package!' do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context 'when free package' do
    before { @package.set_free_package! }

    it 'should re-set the package' do
      @package.should_not be_platinum
    end
  end

  context 'when platinum' do
    before { @package.set_platinum_package! }

    it 'should be platinum' do
      @package.should be_platinum
    end
  end
end

describe Package, '#silver_upgrade_price' do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context 'when free package' do
    before { @package.set_free_package! }

    it 'should return full silver package price' do
      @package.silver_upgrade_price.should eq(Package::PRICE[Package::SILVER])
    end
  end

  context 'when silver' do
    before { @package.set_silver_package! }

    it 'should return zero package price' do
      @package.silver_upgrade_price.should eq(Package::FREE)
    end
  end

  context 'when gold' do
    before { @package.set_gold_package! }

    it 'should return zero package price' do
      @package.silver_upgrade_price.should eq(Package::FREE)
    end
  end

  context 'when platinum' do
    before { @package.set_platinum_package! }

    it 'should return zero package price' do
      @package.silver_upgrade_price.should eq(Package::FREE)
    end
  end
end

describe Package, '#gold_upgrade_price' do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context 'when free package' do
    before { @package.set_free_package! }

    it 'should return full gold package price' do
      @package.gold_upgrade_price.should eq(Package::PRICE[Package::GOLD])
    end
  end

  context 'when silver' do
    before { @package.set_silver_package! }

    it 'should return gold package price minus silver package price' do
      @package.gold_upgrade_price.should eq(Package::PRICE[Package::GOLD] - Package::PRICE[Package::SILVER])
    end
  end

  context 'when gold' do
    before { @package.set_gold_package! }

    it 'should return zero package price' do
      @package.gold_upgrade_price.should eq(Package::FREE)
    end
  end

  context 'when platinum' do
    before { @package.set_platinum_package! }

    it 'should return zero package price' do
      @package.gold_upgrade_price.should eq(Package::FREE)
    end
  end
end

describe Package, '#platinum_upgrade_price' do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context 'when free package' do
    before { @package.set_free_package! }

    it 'should return full platinum package price' do
      @package.platinum_upgrade_price.should eq(Package::PRICE[Package::PLATINUM])
    end
  end

  context 'when silver' do
    before { @package.set_silver_package! }

    it 'should return platinum package price minus silver package price' do
      @package.platinum_upgrade_price.should eq(Package::PRICE[Package::PLATINUM] - Package::PRICE[Package::SILVER])
    end
  end

  context 'when gold' do
    before { @package.set_gold_package! }

    it 'should return platinum package price minus gold package price' do
      @package.platinum_upgrade_price.should eq(Package::PRICE[Package::PLATINUM] - Package::PRICE[Package::GOLD])
    end
  end

  context 'when platinum' do
    before { @package.set_platinum_package! }

    it 'should return zero package price' do
      @package.platinum_upgrade_price.should eq(Package::FREE)
    end
  end
end

describe Package, "#upgrade_price" do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context "when promo code is available" do
    before do
      @promo = FactoryGirl.create(:promo)
      @package.use_promo!(@promo.code)
    end

    it "returns upgrade price with the discount" do
      regular_price = Package::PRICE[Package::SILVER]
      discount_price = regular_price - (regular_price * @promo.discount / 100).round
      @package.upgrade_price(Package::SILVER).should eq(discount_price)
    end
  end

  context "when promo code is not available" do
    it "returns upgrade price without the discount" do
      @package.upgrade_price(Package::SILVER).should eq(Package::PRICE[Package::SILVER])
    end
  end
end

describe Package, "#regular_price" do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context "when upgrading from free package" do
    it "returns a regular upgrade price" do
      @package.regular_price(Package::SILVER).should eq(Package::PRICE[Package::SILVER])
    end
  end

  context "when upgrading from paid package" do
    before { @package.set_silver_package! }

    it "returns a regular upgrade price minus current package price" do
      @package.regular_price(Package::SILVER).should eq(Package::PRICE[Package::SILVER] - Package::PRICE[@package.package])
    end
  end
end

describe Package, "#reserved_upgrade_price" do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context "when package is reserved" do
    context "when upgrading from free package" do
      before { @package.reserve!(Package::SILVER) }

      it "returns a regular package price" do
        @package.regular_price(Package::SILVER).should eq(Package::PRICE[Package::SILVER])
      end
    end

    context "upgrading from paid package" do
      before do 
        @package.set_silver_package!
        @package.reserve!(Package::GOLD)
      end

      it "returns a regular package price minus current package price" do
        @package.regular_price(Package::GOLD).should eq(Package::PRICE[Package::GOLD] - Package::PRICE[@package.package])
      end
    end
  end

  context "when package is not reserved" do
    before { @package.reserved_package = nil }

    it "returns 0 <zero>" do
      @package.reserved_upgrade_price.should eq(0)
    end
  end
end

describe Package, "#reserve!" do
  include PackageSpecHelper
  before { setup_idea_full_environment }

  context "when promo is used" do
    before do
      @promo = FactoryGirl.create(:promo)
      @package.use_promo!(@promo.code)
      @package.reserve!(Package::SILVER)
    end

    it "reserves the package" do
      @package.reserved_package.should_not be_nil
    end

    it "marks the paid field to false" do
      @package.paid?.should eq(false)
    end

    it "marks the promo as used" do
      @package.promo.used?.should be_true
    end
  end

  context "when promo is not used" do
    before { @package.reserve!(Package::SILVER) }

    it "reserves the package" do
      @package.reserved_package.should_not be_nil
    end

    it "marks the paid field to false" do
      @package.paid?.should eq(false)
    end
  end
end

describe Package, "#paid!" do
  include PackageSpecHelper
  before do 
    setup_idea_full_environment
    @package.set_free_package!
    @package.reserve!(Package::SILVER)
    @package.paid!
  end

  it "marks the package as paid" do
    @package.paid?.should be_true
  end

  it "sets the applies the reserved package" do
    @package.package.should eq(Package::SILVER)
  end

  it "sets the idea to startap" do
    @package.idea.startup?.should be_true
  end
end

describe Package, "#use_promo!" do
  include PackageSpecHelper
  before do 
    setup_idea_full_environment
    @promo = FactoryGirl.create(:promo)
  end

  context "when promo is valid" do
    before { @package.use_promo!(@promo.code) }

    it "sets the promo code" do
      @package.promo_code.should eq(@promo.code)
    end
  end

  context "when promo is not valid" do
    before { @package.use_promo!('invalid promo') }

    it "does not set the promo code" do
      @package.promo_code.should be_nil
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
