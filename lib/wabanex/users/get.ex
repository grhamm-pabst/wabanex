defmodule Wabanex.Users.Get do
  import Ecto.Query

  alias Wabanex.{Repo, Training, User}

  def by_id(id) do
    with {:ok, _uuid} <- Ecto.UUID.cast(id),
         %User{} = user <- Repo.get(User, id),
         %User{} = user <- load_training(user) do
      {:ok, user}
    else
      :error -> {:error, "Invalid UUID"}
      nil -> {:error, "User not found"}
    end
  end

  defp load_training(user) do
    today = Date.utc_today()

    query =
      from training in Training,
        where: ^today >= training.start_date and ^today <= training.end_date

    Repo.preload(user, trainings: {first(query, :inserted_at), :exercises})
  end
end
