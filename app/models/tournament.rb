class Tournament < ActiveRecord::Base
  extend Enumerize

  enumerize :category,    in: Settings.enumerize.categories
  enumerize :genre,       in: Settings.enumerize.genre
  enumerize :max_ranking, in: Settings.enumerize.ranking
  enumerize :min_ranking, in: Settings.enumerize.ranking
  enumerize :nature,      in: ['Simple']

  geocoded_by :address_tour

  belongs_to :user

  has_many :notifications,  dependent: :destroy
  has_many :subscriptions,  dependent: :destroy
  has_many :transfers,      dependent: :destroy

  validates :postcode,            presence: { message: "Merci d'indiquer un code postal valide" }
  validates :genre,               presence: { message: "Merci d'indiquer le genre" }
  validates :category,            presence: { message: "Merci d'indiquer la catégorie" }
  validates :starts_on,           presence: { message: "Merci d'indiquer la date de début" }
  validates :ends_on,             presence: { message: "Merci d'indiquer la date de fin" }
  validates :amount,              presence: { message: "Merci d'indiquer le montant des frais d'inscription" }
  validates :city,                presence: { message: "Merci d'indiquer la ville où a lieu le tournoi" }
  validates :address,             presence: { message: "Merci d'indiquer l'addresse des installations" }
  validates :name,                presence: { message: "Merci d'indiquer le nom de la compétition" }
  validates :club_email,          presence: { message: "Merci d'indiquer l'email du club organisateur" }
  validates :club_organisateur,   presence: { message: "Merci d'indiquer le club organisateur" }

  # validates :homologation_number, presence: true, format:{
  #     with:     /2015\d{11}/,
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


  def address_tour
    "#{address} #{city}"
  end

  def address_tour_changed?
    address_changed? || city_changed?
  end

  def open_for_birthdate?(user_birthdate)
    birth_year        = user_birthdate.year
    user_age          = Date.today.year - birth_year

    check_settings    = Settings.tournament_category_checks
    real_age          = check_settings.real_age[category]
    exact_tennis_age  = check_settings.exact_tennis_age[category]
    range_tennis_age  = check_settings.range_tennis_age[category]
    senior_tennis_age = check_settings.senior_tennis_age[category]

    return false if user_age <= 7
    return false if real_age          && real_age != user_age
    return false if exact_tennis_age  && (tennis_year - exact_tennis_age) != birth_year
    return false if range_tennis_age  && (tennis_year - range_tennis_age) != birth_year && (tennis_year - range_tennis_age - 1) != birth_year
    return false if senior_tennis_age && (tennis_year - senior_tennis_age) < birth_year

    true
  end

  def open_for_genre?(user_genre)
    self.genre == user_genre
  end

  def open_for_ranking?(user_ranking)
    ranking_field_name = Settings.user_tournament_ranking_matching[user_ranking]
    ranking_acceptance = self[ranking_field_name]

    (total && ranking_acceptance) == true
  end

  def in_ranking_range(user_ranking, tournament)
    ranking_value = Settings.user_ranking_value[user_ranking]
    tournament_max_ranking_value = Settings.user_ranking_value[tournament.max_ranking]
    tournament_min_ranking_value = Settings.user_ranking_value[tournament.min_ranking]
    if tournament_max_ranking_value >= ranking_value && ranking_value >= tournament_min_ranking_value
      return true
    else
      return false
    end
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
