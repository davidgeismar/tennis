class Subscription < ActiveRecord::Base
  extend Enumerize

  enumerize :status,    in: [:pending, :confirmed, :confirmed_warning, :refused]
  enumerize :fare_type, in: [:standard, :young, :unknown]

  belongs_to :user
  belongs_to :competition

  has_one :tournament,    through:    :competition

  has_many :convocations,           dependent: :destroy
  has_many :mangopay_transactions,  dependent:  :destroy

  validates :user_id, presence: true, uniqueness: { scope: :competition, message: "Vous etes déjà inscrit à ce tournoi dans cette catégorie" }
  validates :competition_id, presence: true
  validates :fare_type, presence: true
  scope :current, -> { joins(competition: :tournament).where('tournaments.ends_on > :today', today: Date.today) }
end
