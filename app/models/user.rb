class User < ActiveRecord::Base
  extend Enumerize

  enumerize :genre,   in: Settings.enumerize.genre
  enumerize :ranking, in: Settings.enumerize.ranking

  devise :invitable,
          :database_authenticatable,
          :registerable,
          :confirmable,
          :recoverable,
          :rememberable,
          :trackable,
          :validatable,
          :omniauthable, omniauth_providers:  [:facebook]

  has_many :subscriptions,  dependent: :destroy
  has_many :tournaments,    dependent: :destroy
  has_many :messages,       dependent: :destroy
  has_many :notifications,  dependent: :destroy

  has_attached_file :picture,           styles: { medium: "300x300>", thumb: "100x100>" }
  has_attached_file :licencepicture,    styles: { medium: "300x300>", thumb: "100x100>" }
  has_attached_file :certifmedpicture,  styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :picture,           content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :licencepicture,    content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :certifmedpicture,  content_type: /\Aimage\/.*\z/

  validates :first_name,  presence: { message: 'Veuillez remplir votre prénom' }, on: :update
  validates :last_name,   presence: { message: 'Veuillez remplir votre nom' },    on: :update

  validates :licence_number, format: {
      with:     /\A\d{7}\D{1}\z/,
      message:  'Le format de votre numéro de licence doit être du type 0930613K'
    }, on: :update

  validates :telephone, format: {
      with:     /\A(\+33)[1-9]([-. ]?[0-9]{2}){4}\z/,
      message:  'Le format de votre numéro doit être du type +33602385414'
    }, allow_blank: true, on: :update

  def self.find_for_facebook_oauth(auth)
    user    = where(email: auth.info.email).first
    user  ||= where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.skip_confirmation!

    user.provider     = auth.provider
    user.uid          = auth.uid
    user.email        = auth.info.email
    user.password     = Devise.friendly_token[0,20]
    user.first_name   = auth.info.first_name
    user.last_name    = auth.info.last_name
    user.picture      = auth.info.image
    user.token        = auth.credentials.token
    user.token_expiry = Time.at(auth.credentials.expires_at)

    user.save

    user
  end

  def age
    Time.current.year - birthdate.year
  end

  def full_name
    if last_name && first_name.nil?
      last_name.capitalize
    elsif first_name && last_name.nil?
      first_name.capitalize
    elsif last_name.nil? && first_name.nil?
      ""
    else
      "#{first_name.capitalize} #{last_name.capitalize}"
    end
  end

  def full_name_inversed
    if last_name && first_name.nil?
      last_name.capitalize
    elsif first_name && last_name.nil?
      first_name.capitalize
    elsif last_name.nil? && first_name.nil?
      ""
    else
      "#{last_name.capitalize} #{first_name.capitalize}"
    end
  end

  def licence_number_custom
   licence_without_white_space = licence_number.split.join
   return licence_without_white_space[0...-1]
  end

  def profile_complete?
    base_fields_complete = (first_name.present? &&
      last_name.present? &&
      telephone.present? &&
      birthdate.present? &&
      licence_number.present?
    )

    if judge
      return base_fields_complete && address.present?
    else
      return base_fields_complete && genre.present? && club.present? && ranking.present?
    end
  end

  private

end
