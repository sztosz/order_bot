defmodule SlackBot.Bot do
  @moduledoc false

  use Slack

  alias SlackBot.Order

  def handle_message(%{type: "message", text: "$ " <> "show"} = message, slack) do
    Order.show
    |> Enum.map(&row_to_string(&1))
    |> Enum.join("\n")
    |> send_message(message.channel, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "add " <> order} = message, slack) do
    case Order.add(order) do
      :ok ->
        send_message("Ok, Jose!", message.channel, slack)
      {:error, response} ->
        send_message(response, message.channel, slack)
    end
  end

  def handle_message(%{type: "message", text: "$ " <> "change " <> order} = message, slack) do
      case Order.change(order) do
        :ok ->
          send_message("Ok, Jose!", message.channel, slack)
        {:error, response} ->
          send_message(response, message.channel, slack)
      end
    end

  def handle_message(_, _), do: :ok

  defp row_to_string(row) do
    "#{row.article} #{row.quantity} #{row.measure_unit}"
  end
end
