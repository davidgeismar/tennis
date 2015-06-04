class Contact < ActiveRecord::Base

  validates :email, presence: :true
  validates :object, presence: :true
  validates :content, presence: :true
end
