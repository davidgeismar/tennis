class Subscription < ActiveRecord::Base
  after_create :send_confirmation_email #inscription déja crée
  after_update :send_update_email #is sending email after payment...wtf ?
  #tracked

  extend Enumerize
  enumerize :status, in: [:pending, :confirmed, :refused]


  belongs_to :user
  belongs_to :tournament

  has_one :disponibility, dependent: :destroy
  has_many :convocations, dependent: :destroy

  validates :user_id, presence: true, uniqueness: { scope: :tournament,
    message: "Vous etes déjà inscrit à ce tournoi" }

  private

  def send_confirmation_email
    SubscriptionMailer.confirmation(self).deliver
  end

  def send_update_email
    if self.status == "confirmed" && self.exported == false
      SubscriptionMailer.confirmed(self).deliver
    elsif self.status == "refused" && self.exported == false
      SubscriptionMailer.refused(self).deliver
    end
  end
end
