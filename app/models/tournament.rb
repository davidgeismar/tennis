class Tournament < ActiveRecord::Base

  geocoded_by :address_tour

  belongs_to :user

  has_one  :mangopay_transaction, dependent: :destroy

  has_many :notifications,  dependent: :destroy
  has_many :subscriptions,  through: :competitions
  has_many :competitions,   dependent: :destroy

  validates :postcode,            presence: { message: "Merci d'indiquer un code postal valide" }
  validates :starts_on,           presence: { message: "Merci d'indiquer la date de début" }
  validates :ends_on,             presence: { message: "Merci d'indiquer la date de fin" }
  validates :amount,              presence: { message: "Merci d'indiquer le montant des frais d'inscription" }
  validates :city,                presence: { message: "Merci d'indiquer la ville où a lieu le tournoi" }
  validates :address,             presence: { message: "Merci d'indiquer l'addresse des installations" }
  validates :name,                presence: { message: "Merci d'indiquer le nom de la compétition" }
  validates :club_email,          presence: { message: "Merci d'indiquer l'email du club organisateur" }
  validates :club_organisateur,   presence: { message: "Merci d'indiquer le club organisateur" }

  # rajouter uniqueness: true
  # validates :homologation_number, presence: true, format:{
  #     with:     /\A2015\d{11}\z/,
  #     message:  "Le format de votre numéro d'homologation doit être du type 201532920076013. Merci de ne pas entrer la lettre du début."
  #   }

  validates :iban, presence: true, format: {
      with:     /\A[a-zA-Z]{2}\d{2}\s*(\w{4}\s*){2,7}\w{1,4}\s*\z/,
      message:  'Le format de votre IBAN doit être du type FR70 3000 2005 5000 0015 7845 Z02'
    }

  validates :bic, presence: true, format: {
      with:     /([a-zA-Z]{4}[a-zA-Z]{2}[a-zA-Z0-9]{2}([a-zA-Z0-9]{3})?)/,
      message:  'Le format de votre BIC doit être du type AXABFRPP  '
    }

  validate :start_date_before_end_date

  after_validation  :geocode,                 if: :address_tour_changed?
  after_save        :send_email_if_accepted,  if: :accepted_changed?

  scope :current, -> { where('ends_on > :today', today: Date.today) }
  scope :passed,  -> { where('ends_on < :today', today: Date.today) }

  def address_tour
    "#{address} #{city}"
  end

  def address_tour_changed?
    address_changed? || city_changed?
  end

  def passed?
    self.ends_on < Date.today
  end

  def tennis_year
    year = ends_on.year

    if ends_on.month >= 9
      year += 1
    end

    year
  end

  private

  def send_email_if_accepted
    if self.accepted
      notification = Notification.create(user_id: self.user.id, content: "#{self.name.upcase} a été accepté par l'équipe WeTennis.", tournament_id: self.id)
      TournamentMailer.accepted(self).deliver
    end
  end

  def start_date_before_end_date
    if starts_on && ends_on && starts_on > ends_on
      errors.add(:starts_on, "Veuillez choisir une date de début avant la date de fin du tournoi")
    end
  end
end
