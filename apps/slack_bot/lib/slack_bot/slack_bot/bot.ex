defmodule SlackBot.Bot do
  @moduledoc false

  use Slack

  alias SlackBot.Order

  def handle_message(%{type: "message", text: "$ " <> "add " <> order} = message, slack) do
    case Order.add(order) do
      :ok ->
        send_message("Ok, Jose!", message.channel, slack)
      {:error, response} ->
        send_message(response, message.channel, slack)
    end
  end

  def handle_message(_, _), do: :ok
end
