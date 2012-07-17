require 'mechanize'
require 'nokogiri'
require 'uri'

class Wormly
  BASE_URL = 'https://www.wormly.com/login'
  
  def self.my_hosts
    raise "WORMLY_EMAIL and WORMLY_PASSWORD are required" unless ENV['WORMLY_EMAIL'] && ENV['WORMLY_PASSWORD']
    agent = Mechanize.new

    page = agent.get BASE_URL
    hosts_page = page.form_with(id: 'login') do |form|
      form.email = ENV['WORMLY_EMAIL']
      form.password = ENV['WORMLY_PASSWORD']
    end.submit
    
    doc = Nokogiri::HTML(hosts_page.body)
    doc.css("#hostlist tbody tr").map do |row|
      {
        webUrl: URI.join(BASE_URL, row.at(".reportcol a")["href"]).to_s,
        lastBuildStatus: row.at(".icon.pass") ? "Success" : "Failure",
        name: row.at(".textualtitle").text
      }
    end
  end
end

if __FILE__ == $0
  require 'pp'
  pp Wormly.my_hosts
end