require 'spec_helper'

describe Question do
  it { should have_db_column(:raw).of_type(:boolean) }
  it { should have_db_column(:question_reference_id).of_type(:integer) }
end