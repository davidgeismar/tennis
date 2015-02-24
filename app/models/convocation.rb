class Convocation < ActiveRecord::Base
  belongs_to :subscription
  validates :date, presence: true
  validates :hour, presence: true

end
