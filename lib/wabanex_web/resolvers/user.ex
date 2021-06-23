defmodule WabanexWeb.Resolvers.User do
  alias Wabanex.Users.{Create, Get}

  def get(%{id: user_id}, _context) do
    Get.by_id(user_id)
  end

  def create(%{input: params}, _context) do
    Create.call(params)
  end
end
