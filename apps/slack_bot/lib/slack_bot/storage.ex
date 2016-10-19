defmodule SlackBot.Storage do
  @moduledoc false

  import Happy
  import Ecto.Query
  alias Ecto.Changeset
  alias PostgresStorage.Order
  alias PostgresStorage.OrderItem
  alias PostgresStorage.Repo

  def show(order) do
    case order do
      nil -> Repo.all(OrderItem.from_opened_order)
      order when is_integer(order) -> Repo.all(OrderItem.from_order(order))
      _ -> {:error, "Wrong argument `#{order}`"}
    end
  end

  def show_all_orders do
    Repo.all(Order)
  end

  def add(article, quantity, measure_unit) do
    happy_path do
      {:error, "Not found"} = OrderItem.get_by_article(article)
      {:ok, order} = Order.opened
      changeset = %{article: article, quantity: quantity, measure_unit: measure_unit}
      {:ok, _} = order
                 |> Ecto.build_assoc(:order_items, changeset)
                 |> Repo.insert
      :ok
    else
      {:ok, %OrderItem{}} -> {:error, "Exists"} # Change this to match OrderItems
      {:error, message} -> {:error, message}
    end
  end

  def change(article, quantity) do
    happy_path do
      {:ok, order_item} = OrderItem.get_by_article(article)
      {:ok, _} = Repo.update(Changeset.change(order_item, %{quantity: quantity}))
      :ok
    else
      {:error, "Not found"} -> {:error, "Not Found"}
      {:error, message} -> {:error, message}
    end
  end

  def remove(article) do
    happy_path do
      {:ok, order_item} = OrderItem.get_by_article(article)
      {:ok, _} = Repo.delete(order_item)
      :ok
    else
      {:error, "Not found"} -> {:error, "Not Found"}
      {:error, message} -> {:error, message}
    end
  end
end
