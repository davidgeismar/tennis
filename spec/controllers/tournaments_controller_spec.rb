require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'



describe TournamentsController do
  render_views
  login_user

  describe "index" do
    it "populates an array of tournaments" do
      tournament = FactoryGirl.create(:tournament, accepted: true)
      get :index
      assigns(:tournaments).should eq([tournament])
    end

    it "returns the :index view"  do
      get :index
      response.should render_template "pages/partials/_no_tournaments"
      # expect(response.body).to include("Il n'y a pas encore de tournoi référencé sur WeTennis")
    end
  end

  describe "show" do
    it "assigns the requested tournament to @tournament" do
       tournament = FactoryGirl.create(:tournament, accepted: true)
       get :show, id: tournament
       assigns(:tournament).should eq(tournament)
      # expect(response.body).to include("s'inscrire")
    end
    it "renders the :show template" do
      get :show
      response.should render_template :show
    end
  end
end
