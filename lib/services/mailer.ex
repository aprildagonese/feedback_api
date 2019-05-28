defmodule Services.Mailer do
  def send_survey_notifications(users) do
    body = Poison.encode!(users)
    url = "http://mail.turingfeedback.com/api/v1/new_survey"

    send_request(body, url)
  end

  def send_welcome_notification(user) do
    body = Poison.encode!(user)
    url = "http://mail.turingfeedback.com/api/v1/welcome"

    send_request(body, url)
  end

  defp send_request(body, url) do
    HTTPoison.start()

    headers = [{"Content-type", "application/json"}]
    options = [recv_timeout: 40_000, timeout: 40_000]

    HTTPoison.post(url, body, headers, options)
  end
end
