require 'faraday'
require 'json'

class NagerService

  def self.us_holidays
    response = conn.get('/api/v3/NextPublicHolidays/US')
    body = parse_response(response)
    holidays = JSON.parse(body[:body])

    three_holidays = holidays[0..2].map do |holiday|
      holiday['name']
    end

    three_holidays
  end

  private

  def self.parse_response(response)
    JSON.parse(response.to_json, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: "https://date.nager.at")
  end
end
