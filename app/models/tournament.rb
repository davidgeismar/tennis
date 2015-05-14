class Tournament < ActiveRecord::Base
  has_many :transfers
  geocoded_by :address_tour
  after_validation :geocode, if: :address_tour_changed?

  def address_tour
    "#{address} #{city}"
  end

  def address_tour_changed?
    address_changed? || city_changed?
  end

  include AlgoliaSearch
  algoliasearch index_name: "tournament#{ENV['ALGOLIA_SUFFIX']}" do
    attribute :genre, :category, :starts_on, :ends_on, :address, :city, :name, :club_organisateur
    attributesToIndex ['city', 'address', 'club_organisateur','starts_on', 'ends_on', 'category', 'name']
  end

  extend Enumerize
  enumerize :genre, in: [:male, :female]
  enumerize :category, in: ['seniors', '35 ans', '40 ans', '45 ans', '50 ans', '55 ans', '60 ans', '70 ans', '75 ans', '80 ans', '9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans', '15-16 ans', '17-18 ans']


  belongs_to :user

  has_many :subscriptions, dependent: :destroy

  validates :genre, presence:  { message: "Merci d'indiquer le genre" }
  validates :category, presence: { message: "Merci d'indiquer la catégorie" }
  validates :starts_on, presence: { message: "Merci d'indiquer la date de début" }
  validates :ends_on, presence: { message: "Merci d'indiquer la date de fin" }
  validates :amount, presence: { message: "Merci d'indiquer le montant des frais d'inscription" }
  validates :city, presence: { message: "Merci d'indiquer la ville où a lieu le tournoi" }
  validates :address, presence: { message: "Merci d'indiquer l'addresse des installations" }
  validates :name, presence: { message: "Merci d'indiquer le nom de la compétition" }
  validates :club_organisateur, presence: { message: "Merci d'indiquer le club organisateur" }
  validate :start_date_before_end_date


  private

  def start_date_before_end_date
    if starts_on > ends_on
      errors.add(:starts_on, "Start date should be before end date")
    end
  end
end


