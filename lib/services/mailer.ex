defmodule Services.Mailer do
  def send_notifications(users) do
    HTTPoison.start()
    body = Poison.encode!(users)

    url = "http://mail.turingfeedback.com/api/v1/messages"
    headers = [{"Content-type", "application/json"}]
    options = [recv_timeout: 40_000, timeout: 40_000]

    HTTPoison.post(url, body, headers, options)
  end
end
