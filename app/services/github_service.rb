require 'faraday'
require 'json'

class GithubService

  TURING_STAFF = %w(BrianZanti timomitchel scottalexandra jamisonordway)

  def self.repo_info
    response = conn.get('/repos/jacobyarborough/little-esty-shop')
    body = parse_response(response)

    body[:name]
  end

  def self.repo_contributors
    response = conn.get('/repos/jacobyarborough/little-esty-shop/stats/contributors')
    body = parse_response(response)

    body.filter_map do |contributor|
      if !TURING_STAFF.include?(contributor[:author][:login])
        "#{contributor[:author][:login]} with #{contributor[:total]} commits."
      end
    end
  end

  def self.pr_info
    response = conn.get('/repos/jacobyarborough/little-esty-shop/pulls?state=closed&per_page=100')
    body = parse_response(response)

    body.count do |pull|
      !TURING_STAFF.include?(pull[:user][:login])
    end
  end

    private

  def self.parse_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new("https://api.github.com")
  end
end
