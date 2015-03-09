class AddAttachmentLicencepictureToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :licencepicture
    end
  end

  def self.down
    remove_attachment :users, :licencepicture
  end
end
