require 'spec_helper'

describe Promo do
  describe Promo, ".with_code" do
  	context "when promo exists" do
      let(:promo) { FactoryGirl.create(:promo, code: '123abc') }

      it "returns a collection" do
        Promo.with_code(promo.code).should eq([promo])
      end
  	end

  	context "when promo does not exists" do
  	 it "returns an empty collection" do
        Promo.with_code('123abc').should eq([])
      end
  	end
  end

  describe Promo, ".get_with_code" do
    context "when promo exists" do
      let(:promo) { FactoryGirl.create(:promo, code: '123abc') }

      it "returns a promo" do
        Promo.get_with_code(promo.code).should eq(promo)
      end
    end

    context "when promo does not exists" do
     it "returns nil" do
        Promo.get_with_code('123abc').should be_nil
      end
    end
  end

  describe Promo, "#expired?" do
    context "when promo is expired" do
      let(:promo) { FactoryGirl.create(:promo, code: '123abc', expires: Time.zone.now - 1.hour) }

      it "returns true" do
        promo.expired?.should be_true
      end
    end

    context "when promo is not expired" do
      let(:promo) { FactoryGirl.create(:promo, code: '123abc', expires: Time.zone.now + 1.hour) }

      it "returns false" do
        promo.expired?.should be_false
      end
    end
  end

  describe Promo, "#valid_promo?" do
    context "when promo is valid" do
      let(:promo) { FactoryGirl.create(:promo, code: '123abc', expires: Time.zone.now + 1.hour, used: false) }

      it "returns true" do
        promo.valid_promo?.should be_true
      end
    end

    context "when promo is not valid" do
      let(:promo) { FactoryGirl.create(:promo, code: '123abc', expires: Time.zone.now - 1.hour, used: true) }

      it "returns false" do
        promo.valid_promo?.should be_false
      end
    end
  end

  describe Promo, "#used!" do
    context "when promo is not used" do
      let(:promo) { FactoryGirl.create(:promo, code: '123abc', used: false) }

      it "marks as used" do
        expect { promo.used! }.to change { promo.used? }.from(false).to(true)
      end
    end

    context "when promo is used" do
      let(:promo) { FactoryGirl.create(:promo, code: '123abc', used: true) }

      it "stays used" do
        expect { promo.used! }.not_to change { promo.used? }
      end
    end
  end
end
