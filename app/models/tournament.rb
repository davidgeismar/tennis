class Tournament < ActiveRecord::Base

   extend Enumerize
    enumerize :genre, in: [:male, :female]
    enumerize :category, in: ['seniors', '35 ans', '40 ans', '45 ans', '50 ans', '55 ans', '60 ans', '70 ans', '75 ans', '80 ans', '9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans', '15-16 ans', '17-18 ans']


  belongs_to :user
  has_many :subscriptions, dependent: :destroy

  validates :genre, presence: true
  validates :category, presence: true
  validates :starts_on, presence: true
  validates :ends_on, presence: true
end
