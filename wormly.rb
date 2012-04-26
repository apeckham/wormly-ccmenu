require 'mechanize'
require 'nokogiri'

class Wormly
  def self.my_hosts
    raise "WORMLY_EMAIL and WORMLY_PASSWORD are required" unless ENV['WORMLY_EMAIL'] && ENV['WORMLY_PASSWORD']
    agent = Mechanize.new

    page = agent.get 'https://www.wormly.com/login'
    hosts_page = page.form_with(id: 'login') do |form|
      form.email = ENV['WORMLY_EMAIL']
      form.password = ENV['WORMLY_PASSWORD']
    end.submit
    
    doc = Nokogiri::HTML(hosts_page.body)
    doc.css("#hostlist tbody tr").map do |row|
      {webUrl: row.at(".reportcol a")["href"], lastBuildStatus: row.at(".icon.pass") ? "Success" : "Failure", name: row.at(".textualtitle").text}
    end
  end
end

if __FILE__ == $0
  require 'pp'
  pp Wormly.my_hosts
end