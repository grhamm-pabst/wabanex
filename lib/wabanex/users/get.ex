defmodule Wabanex.Users.Get do
  alias Wabanex.{Repo, User}

  def by_id(id) do
    with {:ok, _uuid} <- Ecto.UUID.cast(id),
         %User{} = user <- Repo.get(User, id) do
      {:ok, user}
    else
      :error -> {:error, "Invalid UUID"}
      nil -> {:error, "User not found"}
    end
  end
end
