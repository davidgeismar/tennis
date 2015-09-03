class Contact < ActiveRecord::Base
  validates :content, presence: :true
  validates :email,   format: {
                                with:     /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
                                message:  "Merci d'entrer un email valide"
                              }, on: :create
  validates :object,  presence: :true
end
