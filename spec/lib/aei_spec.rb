require 'rails_helper'
require 'factory_girl_rails'
require 'spec_helper'


describe AEI do
  describe "mechanize_aei_login" do
    it "returns a valid html_body"  do
      expect(AEI.new("babas92500", "tencay80").mechanize_aei_login(Mechanize.new)).to be_instance_of(Nokogiri::HTML::Document)
    end
    it "returns a login error"  do
      expect {
        AEI.new("babs92500", "tencay80").mechanize_aei_login(Mechanize.new) }.to raise_error(AEI::LoginError)

    end
  end
end
