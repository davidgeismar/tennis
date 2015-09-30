class AddAttachmentExtradocToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :extradoc
    end
  end

  def self.down
    remove_attachment :users, :extradoc
  end
end
