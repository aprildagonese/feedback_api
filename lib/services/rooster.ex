defmodule Services.Rooster do
  def cohorts do
    HTTPoison.start()

    url =
      "http://turing-rooster.herokuapp.com/api/v1/cohorts?key=OsLvluNTvbQxWRKs0Cnn7CMLVBQ1tF8p"

    response = HTTPoison.get!(url)
    results = Poison.decode!(response.body)
    _data = results["data"]
  end

  def students do
    HTTPoison.start()

    url =
      "http://turing-rooster.herokuapp.com/api/v1/cohorts/active?key=OsLvluNTvbQxWRKs0Cnn7CMLVBQ1tF8p"

    response = HTTPoison.get!(url)
    results = Poison.decode!(response.body)
    _data = results["data"]
  end
end

# import IEx; IEx.pry()
