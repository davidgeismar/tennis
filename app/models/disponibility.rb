class Disponibility < ActiveRecord::Base

  extend Enumerize
  enumerize :week, in: ['Tout le temps', 'le matin', 'à partir de 11h', 'à partir de 12h', 'à partir de 13h', 'à partir de 14h', 'à partir de 15h', 'à partir de 16h', 'à partir de 17h', 'à partir de 18h', 'à partir de 19h', 'à partir de 20h', 'à partir de 21h', 'à partir de 22h', 'à partir de 23h']
  enumerize :saturday, in: ['Toute la journée', 'le matin', 'à partir de 11h', 'à partir de 12h', 'à partir de 13h', 'à partir de 14h', 'à partir de 15h', 'à partir de 16h', 'à partir de 17h', 'à partir de 18h', 'à partir de 19h', 'à partir de 20h', 'à partir de 21h', 'à partir de 22h', 'à partir de 23h']
  enumerize :sunday, in: ['Toute la journée', 'le matin', 'à partir de 11h', 'à partir de 12h', 'à partir de 13h', 'à partir de 14h', 'à partir de 15h', 'à partir de 16h', 'à partir de 17h', 'à partir de 18h', 'à partir de 19h', 'à partir de 20h', 'à partir de 21h', 'à partir de 22h', 'à partir de 23h']
  enumerize :monday, in: ['Toute la journée', 'le matin', 'à partir de 11h', 'à partir de 12h', 'à partir de 13h', 'à partir de 14h', 'à partir de 15h', 'à partir de 16h', 'à partir de 17h', 'à partir de 18h', 'à partir de 19h', 'à partir de 20h', 'à partir de 21h', 'à partir de 22h', 'à partir de 23h']
  enumerize :tuesday, in: ['Toute la journée', 'le matin', 'à partir de 11h', 'à partir de 12h', 'à partir de 13h', 'à partir de 14h', 'à partir de 15h', 'à partir de 16h', 'à partir de 17h', 'à partir de 18h', 'à partir de 19h', 'à partir de 20h', 'à partir de 21h', 'à partir de 22h', 'à partir de 23h']
  enumerize :wednesday, in: ['Toute la journée', 'le matin', 'à partir de 11h', 'à partir de 12h', 'à partir de 13h', 'à partir de 14h', 'à partir de 15h', 'à partir de 16h', 'à partir de 17h', 'à partir de 18h', 'à partir de 19h', 'à partir de 20h', 'à partir de 21h', 'à partir de 22h', 'à partir de 23h']
  enumerize :thursday, in: ['Toute la journée', 'le matin', 'à partir de 11h', 'à partir de 12h', 'à partir de 13h', 'à partir de 14h', 'à partir de 15h', 'à partir de 16h', 'à partir de 17h', 'à partir de 18h', 'à partir de 19h', 'à partir de 20h', 'à partir de 21h', 'à partir de 22h', 'à partir de 23h']
  enumerize :friday, in: ['Toute la journée', 'le matin', 'à partir de 11h', 'à partir de 12h', 'à partir de 13h', 'à partir de 14h', 'à partir de 15h', 'à partir de 16h', 'à partir de 17h', 'à partir de 18h', 'à partir de 19h', 'à partir de 20h', 'à partir de 21h', 'à partir de 22h', 'à partir de 23h']
   belongs_to :subscription

   # validates :week, presence: {message: "Merci d'indiquer vos disponibilités en semaine"}
   validates :saturday, presence: {message: "Merci d'indiquer vos disponibilités pour le samedi"}
   validates :sunday, presence: {message: "Merci d'indiquer vos disponibilités pour le dimanche"}
end