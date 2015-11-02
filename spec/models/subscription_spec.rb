require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'

describe Subscription do
  it "has a valid factory" do
    FactoryGirl.create(:subscription).should be_valid
  end
  it "is invalid without a user"  do
    FactoryGirl.build(:subscription, user: nil).should_not be_valid
  end
  it "is invalid without a competition"  do
    FactoryGirl.build(:subscription, competition: nil).should_not be_valid
  end
  it "is invalid without a fare type"  do
    FactoryGirl.build(:subscription, fare_type: nil).should_not be_valid
  end
end
