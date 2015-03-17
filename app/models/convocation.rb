class Convocation < ActiveRecord::Base

  # tracked

  extend Enumerize
  enumerize :status, in: [:pending, :confirmed, :refused, :cancelled]

  belongs_to :subscription

  validates :subscription_id, presence: true
  validates :date, presence: true
  validates :hour, presence: true
end
