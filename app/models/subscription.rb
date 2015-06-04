class Subscription < ActiveRecord::Base
  after_create :send_confirmation_email
  #tracked

  extend Enumerize
  enumerize :status, in: [:pending, :confirmed, :refused, :cancelled]

  belongs_to :user
  belongs_to :tournament

  has_many :convocations, dependent: :destroy

  validates :user_id, presence: true, uniqueness: { scope: :tournament,
    message: "Vous etes déjà inscrit à ce tournoi" }

  private

  def send_confirmation_email
    SubscriptionMailer.confirmation(self).deliver
  end
end
