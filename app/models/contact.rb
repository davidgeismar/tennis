class Contact < ActiveRecord::Base
  validates :content, presence: :true
  validates :email,   presence: :true
  validates :object,  presence: :true
end
