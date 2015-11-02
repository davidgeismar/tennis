class Competition < ActiveRecord::Base
  extend Enumerize
  enumerize :category,    in: Settings.enumerize.categories
  enumerize :genre,       in: Settings.enumerize.genre
  enumerize :max_ranking, in: Settings.enumerize.ranking
  enumerize :min_ranking, in: Settings.enumerize.ranking
  enumerize :nature,      in: ['Simple']

  belongs_to :tournament
  has_many :subscriptions, dependent: :destroy
  has_many :notifications, dependent: :destroy


  validates :tournament_id,       presence: true
  validates :category,            presence: { message: "Merci d'indiquer la catégorie de l'épreuve" }
  validates :nature,              presence: { message: "Merci d'indiquer la nature de l'épreuve" }
  validates :genre,               presence: { message: "Merci d'indiquer le genre de l'épreuve" }
  validate :min_ranking_inferior_to_max_ranking

  def in_ranking_range?(user_ranking)
    ranking_value                 = Settings.user.ranking_value[user_ranking]
    competition_max_ranking_value = Settings.user.ranking_value[self.max_ranking]
    competition_min_ranking_value = Settings.user.ranking_value[self.min_ranking]

    if competition_max_ranking_value >= ranking_value && ranking_value >= competition_min_ranking_value
      return true
    else
      return false
    end
  end

  def open_for_ranking?(user_ranking)
    ranking_field_name = Settings.user.competition_ranking_matching[user_ranking]
    ranking_acceptance = self[ranking_field_name]

    (total && ranking_acceptance) == true
  end

  def open_for_genre?(user_genre)
    self.genre == user_genre
  end

  def tennis_year
    year = tournament.ends_on.year

    if tournament.ends_on.month >= 9
      year += 1
    end

    year
  end

  def open_for_birthdate?(user_birthdate)
    birth_year        = user_birthdate.year
    user_age          = Date.today.year - birth_year

    check_settings    = Settings.competition_category_checks
    all_age_good      = check_settings.all_age_good[category]
    real_age          = check_settings.real_age[category]
    exact_tennis_age  = check_settings.exact_tennis_age[category]
    range_tennis_age  = check_settings.range_tennis_age[category]
    senior_tennis_age = check_settings.senior_tennis_age[category]

    return false if user_age <= 7
    return false if all_age_good      && (user_age <= 11)
    return false if real_age          && real_age != user_age
    return false if exact_tennis_age  && (tennis_year - exact_tennis_age) > birth_year
    return false if range_tennis_age  && (tennis_year - range_tennis_age) > birth_year && (tennis_year - range_tennis_age - 1) > birth_year
    return false if senior_tennis_age && (tennis_year - senior_tennis_age) < birth_year

    true
  end

  def min_ranking_inferior_to_max_ranking
    competition_max_ranking_value = Settings.user.ranking_value[max_ranking]
    competition_min_ranking_value = Settings.user.ranking_value[min_ranking]

    if min_ranking && max_ranking && competition_min_ranking_value >= competition_max_ranking_value
      errors.add(:max_ranking, "Veuillez choisir un classement maximum supérieur au classement minimum")
    end
  end
end
