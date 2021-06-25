defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do
    test "when a valid id is given, returns the user", %{conn: conn} do
      params = %{email: "grhamm@banana.com", name: "Grhamm", password: "123456"}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
      {
        getUser(id: "#{user_id}"){
          id
          name
          email
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "getUser" => %{
                   "email" => "grhamm@banana.com",
                   "id" => _id,
                   "name" => "Grhamm"
                 }
               }
             } = response
    end

    test "when a invalid id is given, returns an error", %{conn: conn} do
      query = """
      {
        getUser(id: "97e6ddbb-caa4-4749-a18d-beae2c5e1833"){
          id
          name
          email
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"getUser" => nil},
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "User not found",
            "path" => ["getUser"]
          }
        ]
      }

      assert response == expected_response
    end
  end
end
