class NagerService

  def self.us_holidays
     content = conn.get('/2022/US')
     body = parse_response(content)

     body.each do |holiday|
       holiday[:name]
    end
  end

   def self.parse_response(response)
     JSON.parse(response.body, symbolize_names: true)
   end

   def self.conn
     Faraday.new(url: "https://date.nager.at/api/v3/publicholidays")
   end
end
