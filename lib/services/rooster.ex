defmodule Services.Rooster do
  def cohorts do
    HTTPoison.start()

    headers = []
    options = [recv_timeout: 40_000, timeout: 40_000]
    url =
      "http://turing-rooster.herokuapp.com/api/v1/cohorts?key=#{System.get_env("ROOSTER_API_KEY")}"

    response = HTTPoison.get!(url, headers, options)
    results = Poison.decode!(response.body)
    results["data"]
  end

  def students do
    HTTPoison.start()

    headers = []
    options = [recv_timeout: 40_000, timeout: 40_000]
    url =
      "http://turing-rooster.herokuapp.com/api/v1/cohorts/active?key=#{System.get_env("ROOSTER_API_KEY")}"

    response = HTTPoison.get!(url, headers, options)
    results = Poison.decode!(response.body)
    results["data"]
  end
end

# import IEx; IEx.pry()
