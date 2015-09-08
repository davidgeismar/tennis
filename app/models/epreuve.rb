class Epreuve < ActiveRecord::Base
  enumerize :category,    in: Settings.enumerize.categories

   belongs_to :tournament
   has_many :subscriptions,  dependent: :destroy
   has_many :transfers,      dependent: :destroy
   has_one :category,      dependent: :destroy
end