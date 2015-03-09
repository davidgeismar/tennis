class AddAttachmentCertifmedpictureToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :certifmedpicture
    end
  end

  def self.down
    remove_attachment :users, :certifmedpicture
  end
end
