class Message < ActiveRecord::Base
    belongs_to :user
    belongs_to :convocation

    # validates_presence_of :user, :content
  validates :user, presence: { message: 'Pas de message sans expéditeur' }, on: :create
  validates :content, presence: { message: 'Veuillez renseigner vos disponibilités' }, on: :create
end
