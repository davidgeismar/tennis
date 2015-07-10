class AddDetailsToDisponibilities < ActiveRecord::Migration
  def change
    add_column :disponibilities, :monday, :string
    add_column :disponibilities, :tuesday, :string
    add_column :disponibilities, :wednesday, :string
    add_column :disponibilities, :thursday, :string
    add_column :disponibilities, :friday, :string
    add_column :disponibilities, :comment, :text
  end
end
