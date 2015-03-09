class User < ActiveRecord::Base
  after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  extend Enumerize
    enumerize :genre, in: [:male, :female]

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [ :facebook ]
  has_many :subscriptions, dependent: :destroy
  has_many :tournaments, dependent: :destroy
  has_attached_file :picture,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  has_attached_file :licencepicture,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :licencepicture,
    content_type: /\Aimage\/.*\z/

  has_attached_file :certifmedpicture,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :certifmedpicture,
    content_type: /\Aimage\/.*\z/

  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update

  def self.find_for_facebook_oauth(auth)

   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
     user.provider = auth.provider
     user.uid = auth.uid
     user.email = auth.info.email
     user.password = Devise.friendly_token[0,20]
     user.first_name = auth.info.first_name
     user.last_name = auth.info.last_name
     user.picture = auth.info.image
     user.token = auth.credentials.token
     user.token_expiry = Time.at(auth.credentials.expires_at)
   end
 end

  def full_name
    if last_name != nil && first_name.nil?
      "#{last_name.capitalize}"
    elsif first_name != nil && last_name.nil?
      "#{first_name.capitalize}"
    elsif last_name.nil? && first_name.nil?
      ""
    else
      "#{first_name.capitalize} #{last_name.capitalize}"
    end
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver
  end
end
