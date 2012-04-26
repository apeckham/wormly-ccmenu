require 'mechanize'
require 'nokogiri'

class Wormly
  def self.my_hosts(email, password)
    agent = Mechanize.new

    page = agent.get 'https://www.wormly.com/login'
    hosts_page = page.form_with(id: 'login') do |form|
      form.email = email
      form.password = password
    end.submit
    
    doc = Nokogiri::HTML(hosts_page.body)
    doc.css("#hostlist tbody tr").map do |row|
      {webUrl: row.at(".reportcol a")["href"], lastBuildStatus: row.at(".icon .pass") ? "Success" : "Failure", name: row.at(".textualtitle").text}
    end
  end
end

if __FILE__ == $0
  require 'pp'
  raise unless ENV['EMAIL'] && ENV['PASSWORD']
  pp Wormly.my_hosts(ENV['EMAIL'], ENV['PASSWORD'])
end