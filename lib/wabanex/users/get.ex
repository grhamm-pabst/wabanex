defmodule Wabanex.Users.Get do
  alias Wabanex.{Error, Repo, User}

  def by_id(id) do
    with {:ok, _uuid} <- Ecto.UUID.cast(id),
         %User{} = user <- Repo.get(User, id) do
      {:ok, user}
    else
      :error -> {:error, Error.build(:bad_request, "Invalid UUID")}
      nil -> {:error, Error.build(:not_found, "User not found")}
    end
  end
end
