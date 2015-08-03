class Convocation < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: [:pending, :confirmed, :refused, :cancelled]

  belongs_to  :subscription

  has_many    :messages

  validates :date,            presence: true
  validates :hour,            presence: true
  validates :subscription_id, presence: true
end
