defmodule SlackBot.Helpers do
  @moduledoc false

  def user_handler(person, slack) do
    person = normalize_person(person)
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

  defp normalize_person(person) do
    person
    |> String.trim_leading("<@")
    |> String.trim_trailing(">")
  end
end
