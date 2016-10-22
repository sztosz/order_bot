defmodule SlackBot.Bot do
  @moduledoc false

  use Slack

  alias SlackBot.Order

  def handle_message(%{type: "message", text: "$ " <> "show all"} = message, slack) do
    respond(Order.show_all_orders, message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "show"} = message, slack) do
    respond(Order.show, message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "show " <> order} = message, slack) do
    respond(Order.show(order), message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "add " <> order_item} = message, slack) do
    respond(Order.add(order_item), message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "change " <> order_item} = message, slack) do
    respond(Order.change(order_item), message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "remove " <> order_item} = message, slack) do
    respond(Order.remove(order_item), message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "close order"} = message, slack) do
    respond(Order.close, message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "close order " <> order} = message, slack) do
    respond(Order.close(order), message, slack)
  end

  def handle_message(%{type: "message", text: "$ " <> "relay order " <> args} = message, slack) do
    case Order.relay(args) do
      {:ok, person, notify_message, response} ->
        notify(notify_message, person, response, message, slack)
      response ->
        respond(response, message, slack)
    end
  end

  def handle_message(_, _), do: :ok

  defp respond(response, message, slack) do
    case response do
      :ok ->
        send_message("Ok, Jose!", message.channel, slack)
      {:ok, response} ->
        send_message(response, message.channel, slack)
      {:error, response} ->
        send_message(response, message.channel, slack)
    end
  end

  defp notify(notify_message, person, response, message, slack) do
    send_message(notify_message, "@" <> person, slack)
    send_message(response, message.channel, slack)
  end
end
