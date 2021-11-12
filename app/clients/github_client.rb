class GithubClient

  def self.repo_info
    response = conn.get('/repos/jacobyarborough/little-esty-shop')
    parse(response)
  end

  def self.repo_contributors
    response = conn.get('/repos/jacobyarborough/little-esty-shop/stats/contributors')
    parse(response)
  end

  def self.pr_info
    response = conn.get('/repos/jacobyarborough/little-esty-shop/pulls?state=closed&per_page=100')
    parse(response)
  end

  def get_url(url)
    response = Faraday.get("https://api.github.com#{url}")
    JSON.parse(response.body, symbolize_names:true)
  end
end
