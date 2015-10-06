# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


users = User.create([{last_name: "ABITBOL" ,first_name: "BENJAMIN", birthdate: "2001", licence_number: "5935763 R ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ABITBOL"  ,first_name: "ETHAN",birthdate: "2000" ,  licence_number: "5935727 B", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name:"ABOUCAYA" ,first_name: "David",birthdate: ,  licence_number: "9309382 T", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ABRIL" ,first_name:"Antoine" ,birthdate: ,  licence_number: "2496702 F", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ADAM" ,first_name: "ANTOINE",birthdate: ,  licence_number: "3056140 R ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name:"ADAM" ,first_name: "Paul",birthdate: ,  licence_number: "4950305 R ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ALESANDRINI",first_name: "bastien" ,birthdate: ,  licence_number:"2592058 D ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ALESANDRINI" ,first_name: "Jérémy",birthdate: ,  licence_number:"2461614 S ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ALLANIC" ,first_name: "RONAN",birthdate: ,  licence_number: "2426828 F ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "AMOUROUX" ,first_name: "Elias" , birthdate: , licence_number: "8608452 M ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ANDREU" ,first_name: "ROMAN", birthdate: , licence_number: "6360327 Y ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ANGOULVENT" ,first_name: "BENOIT" , birthdate: , licence_number: "5831738 V " , email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ANTZENBERGER",first_name: "JACQUES", birthdate: , licence_number: "6648788 T ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ARNAUD" ,first_name: "Lucien" , birthdate: , licence_number: "5666201 N " , email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ASSARAF",first_name: "Charles", licence_number: "9281537 B ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "ATAMER" ,first_name: "NIL", birthdate: , licence_number: "7685754 E " , email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ATTIAS",first_name: "Nathan", birthdate: , licence_number: "2550603 U ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "AUBERTIN",first_name: "Joachim", birthdate: , licence_number: "6397585 W ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "AUDOLI" ,first_name: "Baptiste", birthdate: , licence_number: "4947977 K ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "AUMAITRE" ,first_name: "Victor", birthdate: , licence_number: "2899553 M ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ALI", first_name: "ALEXANDRE", licence_number: "1955983 T ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name:  "AMZALEUG",first_name: "SIMON", birthdate: , licence_number: "1956018 F ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ASSE",first_name: "Nathan", birthdate: , licence_number: "7095734 D ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "AYATA" ,first_name: "BENJAMIN ", birthdate: , licence_number: "2477746 B ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "BALLAND" ,first_name: "Dany", birthdate: , licence_number: "6956198 J ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "BARRAL" ,first_name: "Maxime", birthdate: , licence_number: "213348 Z ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "BAUMELOU",first_name:"Hadrien", licence_number: "316602 G ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "BENHAIM",first_name:"William", licence_number: " 8777840 E ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "BERTHON",first_name:"Louis", licence_number: " 635128 F ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "BIANCHI",first_name:"GUILLAUME", licence_number: "1955967 A", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "BILLET",first_name:"Gregoire", licence_number: "9126407 G ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "BOUDOU",first_name:"Julien", licence_number: "6223044 C", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "BOULANGER",first_name:"Adrien", licence_number: "9506877 L", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "BOUTTEAU",first_name:"Louis", licence_number: "5156835 E", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "BRACHET",first_name:"Pierre-Pavel", licence_number: "7028242 T", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "BREMME",first_name:"Gabriel", licence_number: "527387 W", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "CACOUB",first_name:"Raphael", licence_number: "1865582 F  ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "CAMMARATA",first_name:"Hugo", licence_number: "8800280 W", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "CAMPO",first_name:"Matthieu", licence_number: "5829827 T", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "CAMUS",first_name:"Léopold", licence_number: "6744308 U", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
   {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  {last_name: "",first_name:"", licence_number: " ", birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }
  ])
# require "mechanize"
# def seed_database
#   agent = Mechanize.new
#   begin
#     login_page = agent.get("https://mon-espace-tennis.fft.fr/")
#   rescue Mechanize::ResponseCodeError => exception
#     if exception.response_code == '403'
#       login_page = exception.page
#     else
#       raise # Some other error, re-raise
#     end
#   end
#   html_body = Nokogiri::HTML(login_page.body)
#   puts html_body
#   form_espace_licencie = login_page.forms.first
#   form_espace_licencie.name = "babas92500"
#   form_login_AEI.pass = "babas92500"
#   agent.submit(form_espace_licencie, form_espace_licencie.buttons.first)
#   page_joueurs = agent.get("https://mon-espace-tennis.fft.fr/recherche-joueur?sexe=H&codeClub=19750195&idClassement=0&perPage=20")
#   html_body = Nokogiri::HTML(page_joueurs.body)
#   html_body.search("table.tableheader-processed td[2]").each do |last_name|
#     puts last_name.text.split.join
#   end
# end

# seed_database



