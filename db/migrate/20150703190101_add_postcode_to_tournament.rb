class AddPostcodeToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :postcode, :string
  end
end
