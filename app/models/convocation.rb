class Convocation < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: [:pending, :confirmed, :refused, :confirmed_by_judge, :cancelled]

  belongs_to  :subscription
  has_one :tournament, through: :subscription

  has_one    :message

  validates :date,            presence: { message: "Veuillez remplir la date de la convocation" }, on: :create
  validates :hour,            presence: { message: "Veuillez remplir l'heure de votre convocation" }, on: :create
  validates :subscription_id, presence: true
  validates :status,          presence: true
end
