class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :convocation
  belongs_to :tournament
  belongs_to :competition
end
