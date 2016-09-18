defmodule SlackBot.Order do
  @moduledoc false

  alias Storage.OrderItem
  alias Storage.Repo

  import Happy

  def show do
    Repo.all(OrderItem)
  end

  def add(order) do
    case String.split(order) do
        [article, quantity, measure_unit] ->
          add(article, quantity, measure_unit)
        [_ | _] ->
          {:error, "I did not understand"}
    end
  end

  def change(order) do
    case String.split(order) do
      [article, quantity] ->
        change(article, quantity)
      [_ | _] ->
        {:error, "I did not understand"}
    end
  end

  defp add(article, quantity, measure_unit) do
    happy_path do
      {quantity, _} =
        Integer.parse(quantity)
      nil = Repo.get_by(OrderItem, article: article)
      {:ok, _} =
        Repo.insert(OrderItem.changeset(%OrderItem{}, %{article: article, quantity: quantity, measure_unit: measure_unit}))
      :ok
    else
      :error -> {:error, "Product quantity has to be an Integer, and you wrote `#{quantity}` "}
      {:error, _} -> {:error, "Inserting went wrong!"}
      %{article: article} -> {:error, "Product #{article} has already been added "}
    end
  end

  defp change(article, quantity) do
    happy_path do
      {quantity, _} =
        Integer.parse(quantity)
      changeset =
        Repo.get_by!(OrderItem, article: article)
      {:ok, _} =
        Repo.update(Ecto.Changeset.change(changeset, quantity: quantity))
      :ok
    else
      :error -> {:error, "Product quantity has to be an Integer, and you wrote `#{quantity}` "}
      {:error, _} -> {:eror, "Updating went wrong"}
      nil -> {:eror, "Can't update #{article} because it hasn't been added yet"}
    end
  end
end
