class Subscription < ActiveRecord::Base

  #tracked

  extend Enumerize
  enumerize :status, in: [:pending, :confirmed, :refused, :cancelled]

  belongs_to :user
  belongs_to :tournament

  has_many :convocations, dependent: :destroy

  validates :user_id, presence: true, uniqueness: { scope: :tournament,
    message: "Vous etes déjà inscrit à ce tournoi" }
end
