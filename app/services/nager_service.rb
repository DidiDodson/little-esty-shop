class NagerService

  def self.us_holidays
     content = conn.get('/api/v3/NextPublicHolidays/US')
     body = parse_response(content)
     body[:name]
  end

   def self.parse_response(response)
     JSON.parse(response.body, symbolize_names: true)
   end

   def self.conn
     Faraday.new(url: "https://date.nager.at")
   end
end
