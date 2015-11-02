require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'



describe TournamentsController do
  render_views
  user = login_user

  describe "index" do
    it "populates an array of tournaments" do
      tournament = FactoryGirl.create(:tournament, accepted: true)
      get :index
      assigns(:tournaments).should eq([tournament])
    end

    it "returns the :index view"  do
      get :index
      if !subject.current_user.judge
        response.should render_template "pages/partials/_no_tournaments"
        # expect(response.body).to include("Il n'y a pas encore de tournoi référencé sur WeTennis")
      else
        response.should render_template "pages/partials/_no_tournaments_judge"
      end
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
      tournament = FactoryGirl.create(:tournament, accepted: true)
      get :show, id: tournament
      response.should render_template :show
    end
  end

  describe "new" do
    it "renders the :new template" do
      get :new, user_id: subject.current_user
      response.should render_template :new
    end
  end

  describe "edit" do
    it "assigns the requested tournament to @tournament" do
      tournament = FactoryGirl.create(:tournament, accepted: true)
      get :edit, user_id: subject.current_user, id: tournament
      assigns(:tournament).should eq(tournament)
    end
    it "renders the :edit template" do
      tournament = FactoryGirl.create(:tournament, accepted: true)
      get :edit, user_id: subject.current_user, id: tournament
      response.should render_template :edit
    end
  end
end
