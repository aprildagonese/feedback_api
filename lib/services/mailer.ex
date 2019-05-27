defmodule Services.Mailer do
  def send_notifications(users) do
    HTTPoison.start()
    body = Poison.encode!(users)

    url = "http://mail.turingfeedback.com/api/v1/messages"
    headers = [{"Content-type", "application/json"}]

    HTTPoison.post(url, body, headers, timeout: 30000)
  end
end
