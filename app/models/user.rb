class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  extend Enumerize
    enumerize :genre, in: [:male, :female]

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :subscriptions, dependent: :destroy
  has_many :tournaments, dependent: :destroy
  has_attached_file :picture,
    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

end
