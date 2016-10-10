defmodule SlackBot.Bot do
  @moduledoc false

  use Slack

  alias SlackBot.Order

  def handle_message(%{type: "message", text: "$ " <> "show"} = message, slack) do
    Order.show
    |> send_message(message.channel, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "add " <> order} = message, slack) do
    respond(Order.add(order), message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "change " <> order} = message, slack) do
    respond(Order.change(order), message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "remove " <> order} = message, slack) do
    respond(Order.remove(order), message, slack)
  end

  def handle_message(_, _), do: :ok

  defp respond(result, message, slack) do
    case result do
      :ok ->
        send_message("Ok, Jose!", message.channel, slack)
      {:error, response} ->
        send_message(response, message.channel, slack)
    end
  end
end
