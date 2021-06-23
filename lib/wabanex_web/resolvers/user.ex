defmodule WabanexWeb.Resolvers.User do
  alias Wabanex.Users.Get

  def get(%{id: user_id}, _context) do
    Get.by_id(user_id)
  end
end
