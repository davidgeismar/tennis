class User < ActiveRecord::Base
  after_update :send_validation_email, if: "judge_was_accepted?"
  extend Enumerize

  enumerize :genre,   in: Settings.enumerize.genre
  enumerize :ranking, in: Settings.enumerize.ranking

  geocoded_by :ip

  devise :invitable,
          :database_authenticatable,
          :registerable,
          :confirmable,
          :recoverable,
          :rememberable,
          :trackable,
          :validatable,
          :omniauthable, omniauth_providers:  [:facebook]

  has_many :disponibilities,  dependent: :destroy
  has_many :messages,         dependent: :destroy
  has_many :notifications,    dependent: :destroy
  has_many :subscriptions,    dependent: :destroy
  has_many :tournaments,      dependent: :destroy

  has_attached_file :certifmedpicture,  styles: { medium: "300x300>", thumb: "100x100>" }
  has_attached_file :extradoc,          styles: { medium: "300x300>", thumb: "100x100>" }
  has_attached_file :licencepicture,    styles: { medium: "300x300>", thumb: "100x100>" }
  has_attached_file :picture,           styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :certifmedpicture,  content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :extradoc,          content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :licencepicture,    content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :picture,           content_type: /\Aimage\/.*\z/

  validates :first_name,  presence: { message: 'Veuillez remplir votre prénom' }, on: :update
  validates :last_name,   presence: { message: 'Veuillez remplir votre nom' },    on: :update
  validates :birthdate, presence: { message: 'Veuillez indiquer votre date de naissance' }, on: :update, :unless => :invitation_token?

  validates :licence_number, format: {
      with:     /\A\d{7}\D{1}\z/,
      message:  'Le format de votre numéro de licence doit être du type 0930613K'
    }, on: :update

  validates :telephone, format: {
      with:     /\A(\+33)[1-9]([-. ]?[0-9]{2}){4}\z/,
      message:  'Le format de votre numéro doit être du type +33602385414'
    }, on: :update

  validates :address, presence: { message: 'Veuillez indiquer votre addresse' }, on: :update, :if => :judge
  validates :club, presence: { message: 'Veuillez indiquer votre club'}, on: :update, :unless => :judge, :unless => :invitation_token?

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

  def eligible_for_young_fare?
     age < Settings.user.young_fare_max_age
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

  def licence_number_custom #licence number without last character
   licence_without_white_space = licence_number.split.join
   return licence_without_white_space[0...-1]
  end

# for Judge I absolutely need address and birthdate to create mangopay legal user
# user can subscribe to tournament without licence picture and certif picture
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
      return base_fields_complete && genre.present? && club.present? && ranking.present? #&& licencepicture_file_size.present? &&
        #certifmedpicture_file_size.present?
    end
  end

  # profile with licence picture & certif picture
  def profile_ultra_complete?
    profile_complete? && licencepicture_file_size.present? && certifmedpicture_file_size.present?
  end

  def reset_password!(new_password, new_password_confirmation)
    self.password = new_password
    self.password_confirmation = new_password_confirmation

    validates_presence_of     :password
    validates_confirmation_of :password
    validates_length_of       :password, within: Devise.password_length, allow_blank: true

    if errors.empty?
      clear_reset_password_token
      after_password_reset
      save(validate: false)
    end
  end

  private

  def send_validation_email
    UserMailer.judge_accepted(self).deliver
  end

  def judge_was_accepted?
    self.judge? && self.accepted_changed? && self.accepted == true
  end
end
