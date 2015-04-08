class Message < ActiveRecord::Base
    belongs_to :user
    belongs_to :convocation

    validates_presence_of :user, :content
end
