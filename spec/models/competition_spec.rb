require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'

describe Competition do
  it "has a valid factory" do
    FactoryGirl.create(:competition).should be_valid
  end
  it "is invalid without a tournament"  do
    FactoryGirl.build(:competition, tournament: nil).should_not be_valid
  end
  it "is invalid without a category"  do
    FactoryGirl.build(:competition, category: nil).should_not be_valid
  end
  it "is invalid without a nature"  do
    FactoryGirl.build(:competition, nature: nil).should_not be_valid
  end
  it "is invalid if i has a min ranking superior or equal to a max ranking" do
    FactoryGirl.build(:competition, min_ranking: "15", max_ranking: "30" ).should_not be_valid
  end
end
