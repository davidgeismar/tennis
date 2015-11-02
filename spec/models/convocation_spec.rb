require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'

describe Convocation do
  it "has a valid factory" do
    FactoryGirl.create(:convocation).should be_valid
  end
  it "is invalid without a date"  do
    FactoryGirl.build(:convocation, date: nil).should_not be_valid
  end
  it "is invalid without a hour"  do
    FactoryGirl.build(:convocation, hour: nil).should_not be_valid
  end
  it "is invalid without a subscription_id"  do
    FactoryGirl.build(:convocation, subscription: nil).should_not be_valid
  end
  it "is invalid without a status" do
    FactoryGirl.build(:convocation, status: nil).should_not be_valid
  end
end
