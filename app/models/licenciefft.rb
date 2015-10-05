class Licenciefft < ActiveRecord::Base
   def self.mechanize_club
    puts "hello"
    agent = Mechanize.new
    agent.get("http://www.rechercheclub.applipub-fft.fr/rechercheclub/")
    form = agent.page.forms.first
    # filling out form for clubs by region
    codeclubs = []
    #club numbers in select
    numbers = (1..38).to_a
    numbers.each do |number|
      form.field_with(:name => 'codeLigue').options[1].select
      page = agent.submit(form, form.buttons.first)
      while lien = page.link_with(:text=>'Suivante')
          body = page.body
          html_body = Nokogiri::HTML(body)
          links = html_body.css('.list').xpath("//table/tbody/tr/td[2]/a[1]")
          links.each do |link|
            purelink = link['href']
            # codeclub is in the link
            purelink[/codeClub=([^&]*)/].gsub('codeClub=', '')
            # adding codeclub to array
            codeclubs << purelink[/codeClub=([^&]*)/].gsub('codeClub=', '')
            # clicking on page suivante
            page = lien.click
          end
      end
      #scrapping last page
      body = page.body
      html_body = Nokogiri::HTML(body)
      links = html_body.css('.list').xpath("//table/tbody/tr/td[2]/a[1]")
      links.each do |link|
        purelink = link['href']
        purelink[/codeClub=([^&]*)/].gsub('codeClub=', '')
        codeclubs << purelink[/codeClub=([^&]*)/].gsub('codeClub=', '')
      end
    end
    return codeclubs
  end

  def self.mechanize_fft
    codeclubs = mechanize_club()
    agent = Mechanize.new
    agent.get("http://edl.app.fft.fr/espacelic/connexion.do")
    form = agent.page.forms.first
    form.login = "557999719620606"
    form.motDePasse = "SDC32920076"
    form.submit
    page2 = agent.get('https://edl.app.fft.fr/espacelic/private/recherchelic.do')
    form2 = agent.page.forms.first
    licencie = []
    codeclubs.each do |codeclub|
      form2.codeClub = codeclub
      sexes = [1, 2]
      sexes.each do |sexe|
          form2.field_with(:name => 'sexe').options[sexe].select
          form2.submit
          page = agent.submit(form2, form2.buttons.first)
          link_number = 2
          while lien = page.link_with(:text=> link_number.to_s)
            link_number = link_number + 1
            body = page.body
            html_body = Nokogiri::HTML(body)
            html_body.css('#personne tbody tr').each do |person|
               licencie_fft = Licenciefft.new
               licencie_fft.full_name = person.css('td').first.text.to_s
               licencie_fft.genre = person.css('td[2]').text.to_s
               licencie_fft.date_of_birth = person.css('td[3]').text.to_s
               licencie_fft.ranking = person.css('td[4] a').text.to_s.split.join
               if person.css('td[6]').text.to_s[9..29]
                  licencie_fft.licence_number = person.css('td[6]').text.to_s[9..29].split.join
               end
               licencie_fft.club = person.css('td[7]').text.to_s.split.join
               licencie_fft.save
            end
            page = lien.click
          end
          # scrapping last page
          body = page.body
          html_body = Nokogiri::HTML(body)
          html_body.css('#personne tbody tr').each do |person|
            licencie_fft = Licenciefft.new
            licencie_fft.full_name = person.css('td').first.text.to_s
            licencie_fft.genre = person.css('td[2]').text.to_s
            licencie_fft.date_of_birth = person.css('td[3]').text.to_s
            licencie_fft.ranking = person.css('td[4] a').text.to_s.split.join
            if person.css('td[6]').text.to_s[9..29]
              licencie_fft.licence_number = person.css('td[6]').text.to_s[9..29].split.join
            end
            licencie_fft.club = person.css('td[7]').text.to_s.split.join
            licencie_fft.save
          end
        end
      end
  end
end

