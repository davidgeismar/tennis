 require 'rubygems'
  require 'nokogiri'
  require 'builder'
  require 'pry'
  require 'mechanize'


   def scrap
    agent = Mechanize.new
        agent.get("http://www.centraliens-lyon.net/gene/main.php?deconecter=1#")
              login_form = page.form_with(:name => "formulaire_login4")
              login_form.login_s = "2007DESIDERFLO0A"
              login_form.pswd_s = "PROMO2007"
              page = agent.submit(login_form, login_form.buttons.first)
              body = page.body
               html_body = Nokogiri::HTML(body)
               puts html_body


    end

    scrap()