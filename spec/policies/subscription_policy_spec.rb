require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'


describe SubscriptionPolicy do
  subject { SubscriptionPolicy.new(user, subscription) }


  context "for a visitor" do
    let(:user) { nil }
    let(:subscription) { FactoryGirl.create(:subscription) }

    it { should_not permit(:create)  }
    it { should_not permit(:new)     }
    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
  end

  context "for a player" do
    let(:user) { FactoryGirl.create(:user, judge: false) }
    let(:subscription) { FactoryGirl.create(:subscription) }

    it { should_not permit(:index)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
  end

  context "for a judge" do
    let(:user) { FactoryGirl.create(:user, judge: true) }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }
  end

  context "for the judge of the competition" do
    let(:user) { FactoryGirl.create(:user) }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }
  end
end
