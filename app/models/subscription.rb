class Subscription < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: [:pending, :confirmed, :confirmed_warning, :refused]

  belongs_to :user
  belongs_to :tournament

  has_one :disponibility, dependent: :destroy

  has_many :convocations, dependent: :destroy

  validates :user_id, presence: true, uniqueness: { scope: :tournament, message: "Vous etes déjà inscrit à ce tournoi" }
end
