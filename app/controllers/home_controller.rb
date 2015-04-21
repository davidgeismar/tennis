class HomeController < ApplicationController
  def find
    @tournament = Tournament.new
    authorize @tournament
  end

  def home
  end
end
