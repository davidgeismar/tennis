class Convocation < ActiveRecord::Base
  # after_create :send_email

  # tracked

  extend Enumerize
  enumerize :status, in: [:pending, :confirmed, :refused, :cancelled]

  belongs_to :subscription
  has_many :messages

  validates :subscription_id, presence: true
  validates :date, presence: true
  validates :hour, presence: true

  private

  def send_email
    ConvocationMailer.welcome(self).deliver
  end
end
