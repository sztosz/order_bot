defmodule SlackBot.Storage do
  @moduledoc false

  import Happy
  import Ecto.Query
  alias Ecto.Changeset
  alias PostgresStorage.Order
  alias PostgresStorage.OrderItem
  alias PostgresStorage.Repo

  def show do
    Repo.all(OrderItem.from_opened_order)
  end

  def add(article, quantity, measure_unit) do
    happy_path do
      {:error, _} = OrderItem.get_by_article(article)
      {:ok, order} = Order.opened
      {:ok, _} = Repo.insert(Ecto.build_assoc(order,
                                                :order_items,
                                                %{article: article, quantity: quantity, measure_unit: measure_unit}))
      :ok
    else
      {:ok, [_|_]} -> {:error, "Exists"} # Change this to match
      {:error, message} -> {:error, message}
    end
  end

  def change(article, quantity) do
    happy_path do
      {:ok, order_item} = OrderItem.get_by_article(article)
      {:ok, _} = Repo.update(Changeset.change(order_item, quantity: quantity))
      :ok
    else
      {:error, "Not found"} -> {:error, "Not Found"}
      {:error, message} -> {:eror, message}
    end
  end

  def remove(article) do
    happy_path do
      {:ok, order_item} = OrderItem.get_by_article(article)
      {:ok, _} = Repo.delete(order_item)
      :ok
    else
      {:error, "Not found"} -> {:error, "Not Found"}
      {:error, message} -> {:eror, message}
    end
  end
end
