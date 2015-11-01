require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'

describe Tournament do
  it "has a valid factory" do
    FactoryGirl.create(:tournament).should be_valid
  end
  it "is invalid without a start date"  do
    FactoryGirl.build(:tournament, starts_on: nil).should_not be_valid
  end
  it "is invalid without a end date"  do
    FactoryGirl.build(:tournament, ends_on: nil).should_not be_valid
  end
  it "is invalid with a start date after an end date"  do
    FactoryGirl.build(:tournament, starts_on: "2015-11-18", ends_on: "2015-10-26").should_not be_valid
  end
end
