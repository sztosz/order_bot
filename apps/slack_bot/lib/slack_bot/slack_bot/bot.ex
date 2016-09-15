defmodule SlackBot.Bot do
  use Slack

  alias Storage.OrderItem
  alias Storage.Repo

  def handle_message(%{type: "message", text: "order " <> order} = message, slack) do
    case String.split(order) do
      [article, quantity, measure_unit] ->
        # DEBUG OUTPUT
        IO.inspect "Article #{article} Quantity #{quantity} Measurement #{measure_unit}"

        with {quantity, _} <- Integer.parse(quantity),
             changeset = OrderItem.changeset(%OrderItem{}, %{name: article, quantity: quantity, measure_unit: measure_unit}),
             {:ok, _} <- Repo.insert(changeset) do
          send_message("Ordered without a problem", message.channel, slack)
        else
          :error -> send_message("There was a problem with the order", message.channel, slack)
        end
      [_ | _] ->
        send_message("I did not understand", message.channel, slack)
    end
  end

  def handle_message(message, _), do: :ok
end
