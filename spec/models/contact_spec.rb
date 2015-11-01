require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'

describe Contact do
  it "has a valid factory" do
    FactoryGirl.create(:contact).should be_valid
  end
  it "is invalid without a content"  do
    FactoryGirl.build(:contact, content: nil).should_not be_valid
  end
  it "is invalid without an object"  do
    FactoryGirl.build(:contact, object: nil).should_not be_valid
  end
  it "is invalid without an email"  do
    FactoryGirl.build(:contact, email: nil).should_not be_valid
  end
  it "returns a contact's full name as a string"
end
