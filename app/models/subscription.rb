class Subscription < ActiveRecord::Base
  extend Enumerize
    # enumerize :status, in: ['en attente', 'confirmé', 'refusé', 'annulé']
  enumerize :status, in: [:pending, :confirmed, :refused, :cancelled]

  belongs_to :user
  belongs_to :tournament
  has_many :convocations, dependent: :destroy
  validates :user_id, presence: true, uniqueness: true

  STATUSES = [:pending, :confirmed, :refused, :cancelled]
end
