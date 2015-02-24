class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :tournament
  has_many :convocations, dependent: :destroy

end
