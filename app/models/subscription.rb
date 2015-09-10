class Subscription < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: [:pending, :confirmed, :confirmed_warning, :refused]

  belongs_to :user
  belongs_to :competition

  has_one :disponibility, dependent:  :destroy
  has_one :tournament,    through:    :competition

  has_many :convocations, dependent: :destroy

  validates :user_id, presence: true, uniqueness: { scope: :competition, message: "Vous etes déjà inscrit à ce tournoi dans cette catégorie" }

  scope :current, -> { joins(competition: :tournament).where('tournaments.ends_on > :today', today: Date.today) }
end
