defmodule SlackBot.Order do
  @moduledoc false

  import Happy
  alias SlackBot.Storage

  def show(order \\ nil) do
    show_order(order)
  end

  def add(order) do
    case String.split(order) do
      [article, quantity, measure_unit] -> add(article, quantity, measure_unit)
      [_|_] -> {:error, "I did not understand"}
    end
  end

  def change(order) do
    case String.split(order) do
      [article, quantity] -> change(article, quantity)
      [_|_] -> {:error, "I did not understand"}
    end
  end

  def remove(order) do
    case String.split(order) do
      [article] -> remove_article(article)
      [_|_] -> {:error, "When removing from order write product name without additional text after space"}
    end
  end

  defp show_order(order) when is_binary(order) do
    case Integer.parse(order) do
      {order, _} -> show_order(order)
      :error -> {:error, argument_error(order)}
    end
  end

  defp show_order(order) do
    case Storage.show(order) do
      nil -> {:error, "There is no opened orders"}
      {:error, message} -> {:error, message}
      orders -> parse_orders(orders)
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

  defp quantity_error(quantity) do
    {:error, "Product quantity has to be an Integer, and you wrote `#{quantity}` "}
  end

  defp not_exists_error(article, verb) do
    {:error, "Can't `#{verb}` `#{article}` because it hasn't been added yet"}
  end

  def argument_error(argument) do
    {:error, "Sorry `#{argument}` is not a valid argument"}
  end

  defp row_to_string(row) do
    "#{row.article} #{row.quantity} #{row.measure_unit}"
  end

  defp parse_orders(orders) do
    orders
    |> Enum.map(&row_to_string(&1))
    |> Enum.join("\n")
  end
end
