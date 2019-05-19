defmodule Services.Rooster do

  def data do
    HTTPoison.start()
    url = "http://turing-rooster.herokuapp.com/api/v1/cohorts/1811-b?key=OsLvluNTvbQxWRKs0Cnn7CMLVBQ1tF8p"
    response = HTTPoison.get! url
    data = Poison.decode(response.body)
  end
end

import IEx; IEx.pry()
