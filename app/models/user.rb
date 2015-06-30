class User < ActiveRecord::Base
  after_create :send_welcome_email


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # include AlgoliaSearch
  # algoliasearch index_name: "user#{ENV['ALGOLIA_SUFFIX']}" do
  #   attribute :email, :licence_number, :ranking, :first_name, :last_name
  #   attributesToIndex ['email', 'licence_number', 'ranking','first_name', 'last_name']
  # end

  extend Enumerize
  enumerize :genre, in: [:male, :female]
  enumerize :ranking, in: ['NC', '40', '30/5', '30/4', '30/3', '30/2', '30/1', '30', '15/5', '15/4', '15/3', '15/2', '15/1', '15', '5/6', '4/6', '3/6', '2/6', '1/6', '0', '-2/6', '-4/6', '-15', '-30']

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

  validates :first_name, presence: { message: 'Veuillez remplir votre prénom' }, on: :update
  validates :last_name, presence: { message: 'Veuillez remplir votre nom' }, on: :update
  validates :licence_number, format:{
        with: /\d{7}\D{1}/,
        message: 'Le format de votre numéro de licence doit être du type 0930613K'
    }, on: :update
  validates :iban, format: {
        with: /\A[a-zA-Z]{2}\d{2}\s*(\w{4}\s*){2,7}\w{1,4}\s*\z/,
        message: 'Le format de votre IBAN doit être du type FR70 3000 2005 5000 0015 7845 Z02'
    }, :allow_blank => true, on: :update
  validates :bic, format: {
        with: /([a-zA-Z]{4}[a-zA-Z]{2}[a-zA-Z0-9]{2}([a-zA-Z0-9]{3})?)/,
        message: 'Le format de votre BIC doit être du type AXABFRPP  '
    }, :allow_blank => true, on: :update

  validates :telephone, format:{
        with: /\A(\+33)[1-9]([-. ]?[0-9]{2}){4}\z/,
        message: 'Le format de votre numéro doit être du type +33602385414'
    }, :allow_blank => true, on: :update

  has_many :messages
  has_many :notifications

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

  # def initialize
  #   @errors = ActiveModel::Errors.new(self)
  # end


  def age
    now = Time.now.utc.to_date
    now.year - birthdate.year - (birthdate.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def full_name
    if last_name && first_name.nil?
      "#{last_name.capitalize}"
    elsif first_name && last_name.nil?
      "#{first_name.capitalize}"
    elsif last_name.nil? && first_name.nil?
      ""
    else
      "#{first_name.capitalize} #{last_name.capitalize}"
    end
  end

  def full_name_inversed
    if last_name && first_name.nil?
      "#{last_name.capitalize}"
    elsif first_name && last_name.nil?
      "#{first_name.capitalize}"
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
  def create_mangopay_natural_user_and_wallet
    natural_user = MangoPay::NaturalUser.create(self.mangopay_user_attributes)


    wallet = MangoPay::Wallet.create({
      Owners: [natural_user["Id"]],
      Description: "My first wallet",
      Currency: "EUR",
      })

    kyc_document = MangoPay::KycDocument.create(natural_user["Id"],{Type: "IDENTITY_PROOF", Tag: "Driving Licence"})

    self.mangopay_natural_user_id= natural_user["Id"]
    self.wallet_id = wallet["Id"]
    self.kyc_document_id = kyc_document["Id"]
    self.save
  end

   def mangopay_user_attributes
    {
      'Email' => self.email,
      'FirstName' => self.first_name,
      'LastName' => self.last_name,  # TODO: Change this! Add 2 columns on users table.
      'Birthday' => self.date_of_birth.to_i,  # TODO: Change this! Add 1 column on users table
      'Nationality' => 'FR',  # TODO: change this!
      'CountryOfResidence' => 'FR' # TODO: change this!
    }
  end

  private


  def send_welcome_email
    UserMailer.welcome(self).deliver
  end
end
