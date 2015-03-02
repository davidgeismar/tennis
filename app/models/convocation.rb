class Convocation < ActiveRecord::Base
   extend Enumerize
    # enumerize :status, in: ['en attente', 'confirmé', 'refusé', 'annulé']
  enumerize :status, in: [:pending, :confirmed, :refused, :cancelled]

  belongs_to :subscription
  validates :subscription_id, presence: true
  validates :date, presence: true
  validates :hour, presence: true


end
