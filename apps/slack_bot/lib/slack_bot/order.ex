defmodule SlackBot.Order do
  @moduledoc false

  import Happy
  alias SlackBot.Storage

  def show(order \\ nil) do
    show_order(order)
  end

  def show_all_orders do
    case Storage.show_all_orders do
      nil -> {:ok, "There are no orders"}
      orders -> {:ok, parse_orders_list(orders)}
    end
  end

  def add(order_item) do
    case String.split(order_item) do
      [article, quantity, measure_unit] -> add(article, quantity, measure_unit)
      [_|_] -> {:error, "I did not understand"}
    end
  end

  def change(order_item) do
    case String.split(order_item) do
      [article, quantity] -> change(article, quantity)
      [_|_] -> {:error, "I did not understand"}
    end
  end

  def remove(order_item) do
    case String.split(order_item) do
      [article] -> remove_article(article)
      [_|_] -> {:error, "When removing from order write product name without additional text after space"}
    end
  end

  def close(order \\ nil) do
    close_order(order)
  end

  def relay(args) do
    case String.split(args) do
      # Pattern matching hacks for dealing with slack auto transforming user handlers
      [id, person] -> relay_order(id, person)
      [person] -> relay_order(nil, person)
      _ -> {:error, "Wrong arguments"}
    end
  end


  defp show_order(order) when is_binary(order) do
    case Integer.parse(order) do
      {id, _} -> show_order(id)
      :error -> argument_error(order)
    end
  end

  defp show_order(id) do
    case Storage.show(id) do
      nil -> {:error, "There is no opened orders"}
      {:error, message} -> {:error, message}
      order -> {:ok, parse_order(order)}
    end
  end

  defp add(article, quantity, measure_unit) do
    happy_path do
      {quantity, _} = Integer.parse(quantity)
      :ok = Storage.add(article, quantity, measure_unit)
      :ok
    else
      :error -> quantity_error(quantity)
      {:error, "Exists"} -> {:error, "Product `#{article}` has already been added, please `change` existing one "}
      {:error, message} -> {:error, message}
    end
  end

  defp change(article, quantity) do
    happy_path do
      {quantity, _} = Integer.parse(quantity)
      :ok = Storage.change(article, quantity)
      :ok
    else
      :error -> {:error, quantity_error(quantity)}
      {:error, "Not Found"} -> not_exists_error(article, "update")
      {:error, message} -> {:eror, message}
    end
  end

  defp remove_article(article) do
    happy_path do
      :ok = Storage.remove(article)
      :ok
    else
      {:error, "Not Found"} -> not_exists_error(article, "remove")
      {:error, message} -> {:eror, message}
    end
  end

  defp close_order(order) when is_binary(order) do
    case Integer.parse(order) do
      {id, _} -> close_order(id)
      :error -> argument_error(order)
    end
  end

  defp close_order(id) do
    case Storage.close(id) do
      nil -> {:error, "That order was not opened"}
      {:error, message} -> {:error, message}
      :ok -> {:ok, "Order was closed"}
    end
  end

  defp relay_order(id, person) when is_binary(id) do
    case Integer.parse(id) do
      {id, _} -> relay_order(id, person)
      :error -> argument_error(id)
    end
  end

  defp relay_order(id, person) do
    case show_order(id) do
      {:error, message} ->
        {:error, message}
      {:ok, message} ->
        # TODO: add logic to respond from SlackBot only when notification gets sent.
        {:ok, person, message, "Order was sent"}
    end
  end
  defp quantity_error(quantity) do
    {:error, "Product quantity has to be an Integer, and you wrote `#{quantity}` "}
  end

  defp not_exists_error(article, verb) do
    {:error, "Can't `#{verb}` `#{article}` because it hasn't been added yet"}
  end

  def argument_error(argument) do
    {:error, "Sorry `#{argument}` is not a valid argument"}
  end

  defp parse_order(order) do
    order
    |> Enum.map(&order_row_to_string(&1))
    |> Enum.join("\n")
  end

  defp parse_orders_list(orders) do
    orders
    |> Enum.map(&orders_list_row_to_string(&1))
    |> Enum.join("\n")
  end

  defp order_row_to_string(row) do
    "#{row.article} #{row.quantity} #{row.measure_unit}"
  end

  defp orders_list_row_to_string(row) do
   "ID: #{row.id} FROM: #{row.inserted_at} CLOSED: #{row.closed} SENT: #{row.sent}"
  end
end
