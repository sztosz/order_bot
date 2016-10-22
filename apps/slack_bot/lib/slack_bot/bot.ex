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
        person
        |> String.trim_leading("<@")
        |> String.trim_trailing(">")
        |> normalize_person_to_user_handler(slack)
        |> notify(notify_message, response, message, slack)
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

  defp notify(person, notify_message, response, message, slack) do
    send_message(notify_message, "@" <> person, slack)
    send_message(response, message.channel, slack)
  end

  defp normalize_person_to_user_handler(person, slack) do
    slack.users
    |> Map.values
    |> find_user_by_name_or_id(person)
    |> Map.get(:name)
  end

  defp find_user_by_name_or_id(slack_user_map, person) do
    case Enum.find(slack_user_map, fn user -> user.name == person end) do
      nil -> Enum.find(slack_user_map, %{}, fn user -> user.id == person end)
      handle -> handle
    end
  end
end
