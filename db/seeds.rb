# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


users = User.create([{last_name: "ABITBOL" ,first_name: "BENJAMIN", licence_number: "5935763 R ", email: Faker::Internet.email, address: "17 bd d'argension 92200 Neuilly",  password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ABITBOL"  ,first_name: "ETHAN", licence_number: "5935727 B", email: Faker::Internet.email, password: Faker::Internet.password, address: "17 bd d'argension 92200 Neuilly", confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name:"ABOUCAYA" ,first_name: "David",  licence_number: "9309382 T", email: Faker::Internet.email, password: Faker::Internet.password, address: "17 bd d'argension 92200 Neuilly", confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ABRIL" ,first_name:"Antoine" ,  licence_number: "2496702 F", email: Faker::Internet.email, password: Faker::Internet.password, address: "17 bd d'argension 92200 Neuilly", confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ADAM" ,first_name: "ANTOINE",  licence_number: "3056140 R ", email: Faker::Internet.email, password: Faker::Internet.password, address: "17 bd d'argension 92200 Neuilly", confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name:"ADAM" ,first_name: "Paul",  licence_number: "4950305 R ", email: Faker::Internet.email, password: Faker::Internet.password, address: "17 bd d'argension 92200 Neuilly",confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ALESANDRINI",first_name: "bastien" ,  licence_number:"2592058 D ", email: Faker::Internet.email, password: Faker::Internet.password, address: "17 bd d'argension 92200 Neuilly", confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ALESANDRINI" ,first_name: "Jérémy",  licence_number:"2461614 S ", email: Faker::Internet.email, password: Faker::Internet.password, address: "17 bd d'argension 92200 Neuilly",confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ALLANIC" ,first_name: "RONAN",  licence_number: "2426828 F ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AMOUROUX" ,first_name: "Elias", licence_number: "8608452 M ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ANDREU" ,first_name: "ROMAN", licence_number: "6360327 Y ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ANGOULVENT" ,first_name: "BENOIT", licence_number: "5831738 V " , email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ANTZENBERGER",first_name: "JACQUES", licence_number: "6648788 T ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ARNAUD" ,first_name: "Lucien" , licence_number: "5666201 N " , email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ASSARAF", first_name: "Charles", licence_number: "9281537 B ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ATAMER", first_name: "NIL", licence_number: "7685754 E " , email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ATTIAS",first_name: "Nathan", licence_number: "2550603 U ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AUBERTIN",first_name: "Joachim", licence_number: "6397585 W ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AUDOLI" ,first_name: "Baptiste", licence_number: "4947977 K ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AUMAITRE" ,first_name: "Victor", licence_number: "2899553 M ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ALI", first_name: "ALEXANDRE", licence_number: "1955983 T ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name:  "AMZALEUG",first_name: "SIMON", licence_number: "1956018 F ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ASSE",first_name: "Nathan", licence_number: "7095734 D ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AYATA" ,first_name: "BENJAMIN ", licence_number: "2477746 B ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BALLAND" ,first_name: "Dany", licence_number: "6956198 J ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BARRAL" ,first_name: "Maxime", licence_number: "213348 Z ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BAUMELOU",first_name:"Hadrien", licence_number: "316602 G ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BENHAIM",first_name:"William", licence_number: " 8777840 E ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BERTHON",first_name:"Louis", licence_number: " 635128 F ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BIANCHI",first_name:"GUILLAUME", licence_number: "1955967 A", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now) },
  {last_name: "BILLET",first_name:"Gregoire", licence_number: "9126407 G ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BOUDOU",first_name:"Julien", licence_number: "6223044 C", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BOULANGER",first_name:"Adrien", licence_number: "9506877 L", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BOUTTEAU",first_name:"Louis", licence_number: "5156835 E", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BRACHET",first_name:"Pierre-Pavel", licence_number: "7028242 T", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "BREMME",first_name:"Gabriel", licence_number: "527387 W", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "CACOUB",first_name:"Raphael", licence_number: "1865582 F  ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "CAMMARATA",first_name:"Hugo", licence_number: "8800280 W", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "CAMPO",first_name:"Matthieu", licence_number: "5829827 T", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "CAMUS",first_name:"Léopold", licence_number: "6744308 U", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ABADA OLO",first_name:"Stéphane Aristide", licence_number: "6007983 R ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ABADIA",first_name:"VLADIMIR", licence_number: " 2263135 D", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ABISDID",first_name:"ACHRAF", licence_number: "2263224 A", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
   {last_name: "ABIVEN",first_name:"ANES", licence_number: "2263230 G", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ABOULKHATIB", first_name:"JEREMIE", licence_number: "2263243 W", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ABOULKHATIB FOURNAUD",first_name:"ARTHUR", licence_number: "2263245 Y ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ABOULKHATIB FOURNAUD",first_name:"SAM", licence_number: "2263256 K", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ABOUZID",first_name:"Logmen", licence_number: "2368834 U", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ADDOH",first_name:"AXEL", licence_number: " 8398492 V", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ADELFANG",first_name:"EMMANUEL", licence_number: "2263260 P", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AFDJEI",first_name:"cyrus", licence_number: "1357089 W ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AFDJEI",first_name:"ramin", licence_number: "1357122 G ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AGHA",first_name:"armand", licence_number: "8593623 U", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AGUIAR",first_name:"RODRIGO", licence_number: "1701987 K", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AKOUN",first_name:"benjamin", licence_number: " 4407975 B ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AKPAKOUN",first_name:"BENOIT", licence_number: "2263312 W ", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "AKPAKOUN",first_name:"JEAN", licence_number: "2263281 M", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ALAZARD",first_name:"CHARLES", licence_number: "2265511 L", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  {last_name: "ALAZARD",first_name:"LAURENT", licence_number: "2266167 Z", email: Faker::Internet.email, password: Faker::Internet.password, confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)  },
  ])

  admin = User.create([{last_name: "GEISMAR" ,first_name: "David", licence_number: "0930613K ", email: "davidgeismar@hotmail.fr", password: "12345678", confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now), admin: true, ranking: "15", telephone: "+33666027414"  }])
  judge = User.create([{last_name: "Dupuis" ,first_name: "Henri", licence_number: "0930613K ", email: "judge@hotmail.fr", address: "17 bd d'argension 92200 Neuilly", password: "12345678", confirmation_sent_at: Faker::Time.between(DateTime.now - 1, DateTime.now), confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now), admin: true, ranking: "15", telephone: "+33666027414"  }])


# users.each do |user|
#   Subscription.create([{user: user, status: "confirmed", exported: false, funds_sent: true, competition_id: "2", fare_type: "standard"}])
# end
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



