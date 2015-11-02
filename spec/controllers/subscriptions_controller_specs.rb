require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'



describe SubscriptionsController do
  render_views
  user = login_user

  describe "index" do
    it "populates an array of subscriptions" do
      competition = FactoryGirl.create(:competition)
      subscription = FactoryGirl.create(:subscription, competition: competition)
      get :index, competition_id: competition
      assigns(:subscriptions).should eq([subscription])
    end
    it "returns the :index view"  do

      tournament = FactoryGirl.create(:tournament)
      competition = FactoryGirl.create(:competition, tournament: tournament)
      subscription = FactoryGirl.create(:subscription, competition: competition)
      get :index, competition_id: competition
      response.should render_template :index
    end
  end

  describe "new" do
    it "renders the :multiple_new template" do
      tournament = FactoryGirl.create(:tournament)
      get :multiple_new, tournament_id: tournament
      response.should render_template :multiple_new
    end
  end

  describe "edit" do
    it "assigns the requested subscription to @subscription" do
      subscription = FactoryGirl.create(:subscription)
      get :edit, user_id: subject.current_user, id: subscription
      assigns(:subscription).should eq(subscription)
    end
    it "renders the :edit template" do
      subscription = FactoryGirl.create(:subscription)
      get :edit, user_id: subject.current_user, id: subscription
      response.should render_template :edit
    end
  end
end

