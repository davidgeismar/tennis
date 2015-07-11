require 'mechanize'

namespace :fft_scrapper do
  desc "Launch FFT scrapping"
  task run: :environment do
    # FIXME

    # FFT
    agent = Mechanize.new
    agent.get("http://edl.app.fft.fr/espacelic/connexion.do")

    form = agent.page.forms.first
    form.login = "557999719620606"
    form.motDePasse = "SDC32920076"
    form.submit

    page2 = agent.get('http://edl.app.fft.fr/espacelic/private/recherchelic.do?echelon=&d-4021046-p=2&codeClub=34940013&numeroLicence=&prenom=&dateClasst=&dispatch=rechercher&nom=&sexe=H')
    body = page2.body
    html_body = Nokogiri::HTML(body)

    puts "Nombre de ligne " + html_body.css('#personne tbody tr').count.to_s
    html_body.css('#personne tbody tr').each do |person|
      puts person.css('td').first.text.to_s
    end


    # CLUB
    agent = Mechanize.new
    agent.get("http://www.rechercheclub.applipub-fft.fr/rechercheclub/")

    form = agent.page.forms.first
    form.field_with(:name => 'codeLigue').options[0].select
    form.submit

    page2 = agent.get('http://www.rechercheclub.applipub-fft.fr/rechercheclub/club.do?codeClub=01670001&millesime=2015')
    body = page2.body
    html_body = Nokogiri::HTML(body)

    codeclub = html_body.search('.form').children("tr:first").children("th:first").to_i
    @codeclubs << codeclub

    filepath  = '/Users/davidgeismar/documents/codeclubs.xml'
    builder   = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
       xml.root {
        xml.codeclubs {
          @codeclubss.each do |c|
            xml.codeclub {
              xml.code_   c.code
            }
          end
        }
      }
    end
  end
end