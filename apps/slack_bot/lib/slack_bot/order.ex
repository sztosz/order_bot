defmodule SlackBot.Order do
  @moduledoc false

  alias Ecto.Changeset
  alias Storage.OrderItem
  alias Storage.Repo

  import Happy

  def show do
    Repo.all(OrderItem)
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

  defp add(article, quantity, measure_unit) do
    happy_path do
      {quantity, _} = Integer.parse(quantity)
      nil = Repo.get_by(OrderItem, article: article)
      {:ok, _} = Repo.insert(OrderItem.changeset(
                   %OrderItem{},
                   %{article: article, quantity: quantity, measure_unit: measure_unit}))
      :ok
    else
      :error -> {:error, "Product quantity has to be an Integer, and you wrote `#{quantity}` "}
      {:error, _} -> {:error, "Inserting went wrong!"}
      %{article: article} -> {:error, "Product #{article} has already been added "}
    end
  end

  defp change(article, quantity) do
    happy_path do
      {quantity, _} = Integer.parse(quantity)
      {:ok, order_item} =OrderItem.get_by_article(article)
      {:ok, _} = Repo.update(Changeset.change(order_item, quantity: quantity))
      :ok
    else
      :error -> {:error, "Product quantity has to be an Integer, and you wrote `#{quantity}` "}
      {:error, 'Not found'} -> {:error, "Can't update #{article} because it hasn't been added yet"}
      {:error, _} -> {:eror, "Updating went wrong"}
    end
  end

  defp remove_article(article) do
    happy_path do
      {:ok, order_item} = OrderItem.get_by_article(article)
      {:ok, _} = Repo.delete(order_item)
      :ok
    else
      {:error, 'Not found'} -> {:error, "Can't delete #{article} because it hasn't been added yet"}
      {:error, _} -> {:eror, "Deleting went wrong"}
    end
  end
end
