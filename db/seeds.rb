# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


users = User.create([{last_name: "ABITBOL" ,first_name: "BENJAMIN", birthdate: "2001", licence_number: "5935763 R ", email: Faker::Internet.email, password: Faker::Internet.password }, {last_name: ,first_name:, licence_number:, birthdate: ,  email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ABITBOL"  ,first_name: "ETHAN",birthdate: "2000" ,  licence_number: "5935727 B", email: Faker::Internet.email, password: Faker::Internet.password }, {last_name:"ABOUCAYA" ,first_name: "David",birthdate: ,  licence_number: "9309382 T", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ABRIL" ,first_name:"Antoine" ,birthdate: ,  licence_number: "2496702 F", email: Faker::Internet.email, password: Faker::Internet.password }, {last_name: "ADAM" ,first_name: "ANTOINE",birthdate: ,  licence_number: "3056140 R ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name:"ADAM" ,first_name: "Paul",birthdate: ,  licence_number: "4950305 R ", email: Faker::Internet.email, password: Faker::Internet.password }, {last_name: "ALESANDRINI",first_name: "bastien" ,birthdate: ,  licence_number:"2592058 D ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: "ALESANDRINI" ,first_name: "Jérémy",birthdate: ,  licence_number:"2461614 S ", email: Faker::Internet.email, password: Faker::Internet.password }, {last_name: "ALLANIC" ,first_name: "RONAN",birthdate: ,  licence_number: "2426828 F ", email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: ,first_name:, birthdate: , licence_number:, email: Faker::Internet.email, password: Faker::Internet.password }, {last_name: ,first_name:, birthdate: , licence_number:, email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: ,first_name:, birthdate: , licence_number:, email: Faker::Internet.email, password: Faker::Internet.password }, {last_name: ,first_name:, birthdate: , licence_number:, email: Faker::Internet.email, password: Faker::Internet.password },
  {last_name: ,first_name:, birthdate: , licence_number:, email: Faker::Internet.email, password: Faker::Internet.password }, {last_name: ,first_name:, licence_number:, birthdate: , email: Faker::Internet.email, password: Faker::Internet.password }])
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



