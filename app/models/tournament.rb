class Tournament < ActiveRecord::Base
  has_many :transfers
  geocoded_by :address_tour
  after_validation :geocode, if: :address_tour_changed?
  after_save :send_email_if_accepted, if: :accepted_changed?

  def address_tour
    "#{address} #{city}"
  end

  def address_tour_changed?
    address_changed? || city_changed?
  end

  extend Enumerize
  enumerize :genre, in: [:male, :female]
  enumerize :category, in: ['seniors', '35 ans', '40 ans', '45 ans', '50 ans', '55 ans', '60 ans', '70 ans', '75 ans', '80 ans', '9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans', '15-16 ans', '17-18 ans']
  enumerize :min_ranking, in: ['NC', '40', '30/5', '30/4', '30/3', '30/2', '30/1', '30', '15/5', '15/4', '15/3', '15/2', '15/1', '15', '5/6', '4/6', '3/6', '2/6', '1/6', '0', '-2/6', '-4/6', '-15', '-30']
  enumerize :max_ranking, in: ['NC', '40', '30/5', '30/4', '30/3', '30/2', '30/1', '30', '15/5', '15/4', '15/3', '15/2', '15/1', '15', '5/6', '4/6', '3/6', '2/6', '1/6', '0', '-2/6', '-4/6', '-15', '-30']
  enumerize :nature, in: ['Simple']
  belongs_to :user
  has_many :notifications, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :postcode, presence:  { message: "Merci d'indiquer un code postal valide" }
  validates :genre, presence:  { message: "Merci d'indiquer le genre" }
  validates :category, presence: { message: "Merci d'indiquer la catégorie" }
  validates :starts_on, presence: { message: "Merci d'indiquer la date de début" }
  validates :ends_on, presence: { message: "Merci d'indiquer la date de fin" }
  validates :amount, presence: { message: "Merci d'indiquer le montant des frais d'inscription" }
  validates :city, presence: { message: "Merci d'indiquer la ville où a lieu le tournoi" }
  validates :address, presence: { message: "Merci d'indiquer l'addresse des installations" }
  validates :name, presence: { message: "Merci d'indiquer le nom de la compétition" }
  validates :club_organisateur, presence: { message: "Merci d'indiquer le club organisateur" }
  validates :homologation_number, presence: true, format:{
        with: /2015\d{11}/,
        message: "Le format de votre numéro d'homologation doit être du type 201532920076013"
    }, on: :create
  validate :start_date_before_end_date


  private


  def send_email_if_accepted
    if self.accepted
      @notification = Notification.new(user_id: self.user.id, content: "#{self.name.upcase} a été accepté par l'équipe WeTennis.", tournament_id: self.id)
      @notification.save
      TournamentMailer.accepted(self).deliver
    end
  end

  def start_date_before_end_date
    if starts_on && ends_on && starts_on > ends_on
      errors.add(:starts_on, "Veuillez choisir une date de début avant la date de fin du tournoi")
    end
  end
end


