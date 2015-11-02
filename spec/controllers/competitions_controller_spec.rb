require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'



describe CompetitionsController do
  render_views
  login_user

  describe "create" do
    it "creates a new subscription" do
      competition = FactoryGirl.create(:subscription)
      get :index
      assigns(:competitions).should eq([competition])
    end

    it "returns the :index view"  do
      get :index
      response.should render_template "pages/partials/_no_competitions"
      # expect(response.body).to include("Il n'y a pas encore de tournoi référencé sur WeTennis")
    end
  end

  describe "show" do
    it "assigns the requested competition to @competition" do
       competition = FactoryGirl.create(:competition, accepted: true)
       get :show, id: competition
       assigns(:competition).should eq(competition)
      # expect(response.body).to include("s'inscrire")
    end
    it "renders the :show template" do
      get :show
      response.should render_template :show
    end
  end
end
