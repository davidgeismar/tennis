class Convocation < ActiveRecord::Base
  belongs_to :subscription
  validates :subscription_id, presence: true
  validates :date, presence: true
  validates :hour, presence: true

  STATUSES = [ :confirmed, :refused, :cancelled]

end
