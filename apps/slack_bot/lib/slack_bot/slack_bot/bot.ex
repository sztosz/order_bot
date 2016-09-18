defmodule SlackBot.Bot do
  use Slack

  def handle_message(%{type: "message", text: "$ " <> "add " <> order} = message, slack) do
    case String.split(order) do
      [article, quantity, measure_unit] ->
        {_, response} = SlackBot.Order.add(article, quantity, measure_unit)
        send_message(response, message.channel, slack)
      [_ | _] ->
        send_message("I did not understand", message.channel, slack)
    end
  end

  def handle_message(message, _), do: :ok
end
