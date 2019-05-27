require 'net/http'
require 'time'
require 'json'

class Foot 
  def initialize; end 

  # api call resturns with current truck data
  def self.get_truck_data
    puts "here in get_truck_data"
    url = URI.parse('http://data.sfgov.org/resource/bbb8-hzi6.json')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
    }
    parsed_response = JSON.parse(res.body)
    return parsed_response
  end 

  # get today's date
  def self.get_time 
    return Time.now
  end 

  # trucks open on current day 
  def trucks_open_today
    trucks = self.class.get_truck_data
    date = self.class.get_time

    trucks_today = []
    trucks.each do |truck|
      if date.strftime("%A") == truck["dayofweekstr"]
        trucks_today << truck["applicant"]
      end 
    end
    p trucks_today
  end 

  # trucks open at current time
  def trucks_currently_open
    trucks = self.class.get_truck_data
    date = self.class.get_time

    trucks_open_now = []
    trucks.each do |truck|
      if date.strftime('%H:%M') <= truck["end24"] && 
        date.strftime('%H:%M') > truck["start24"]
        trucks_open_now << truck["applicant"]
      end 
    end
    p trucks_open_now
  end 
end

run = Foot.new 
run.trucks_currently_open