require 'spec_helper'

describe Order do
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:express_payer_id).of_type(:string) }
  it { should have_db_column(:first_name).of_type(:string) }
  it { should have_db_column(:last_name).of_type(:string) }
  it { should have_db_column(:ip_address).of_type(:string) }
  it { should have_db_column(:package_id).of_type(:integer) }
  it { should have_db_column(:package_code).of_type(:string) }

  it { should belong_to(:user) }
  it { should belong_to(:user) }
  it { should have_many(:transactions) }

  describe ".purchase" do
    before do
      #@order = create(:order)
    end

    it "should create transaction" do
      pending "purchase pending tests"
    end

  end

end
