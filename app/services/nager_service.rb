require 'faraday'
require 'json'

class NagerService

  def self.us_holidays
     response = conn.get('/NextPublicHolidays/US')
     body = parse_response(response)

  end

  private

  def self.parse_response(response)
    # require "pry"; binding.pry
     JSON.parse(response.to_json, symbolize_names: true)
  end

  def self.conn
     Faraday.new(url: "https://date.nager.at/api/v3")
  end
end
