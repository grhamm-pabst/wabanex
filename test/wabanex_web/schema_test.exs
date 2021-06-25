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
            "locations" => [%{"column" => 5, "line" => 2}],
            "message" => "User not found",
            "path" => ["getUser"]
          }
        ]
      }

      assert response == expected_response
    end
  end

  describe "users mutations" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            name: "Grhamm",
            email: "grhammpabst123@gmail.com",
            password: "123456"
          }){
            id
            name
            email
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "createUser" => %{
                   "email" => "grhammpabst123@gmail.com",
                   "id" => _id,
                   "name" => "Grhamm"
                 }
               }
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            name: "G",
            email: "grhammpabst",
            password: "12345"
          }){
            id
            name
            email
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"createUser" => nil},
        "errors" => [
          %{
            "locations" => [%{"column" => 5, "line" => 2}],
            "message" => "email has invalid format",
            "path" => ["createUser"]
          },
          %{
            "locations" => [%{"column" => 5, "line" => 2}],
            "message" => "name should be at least 2 character(s)",
            "path" => ["createUser"]
          },
          %{
            "locations" => [%{"column" => 5, "line" => 2}],
            "message" => "password should be at least 6 character(s)",
            "path" => ["createUser"]
          }
        ]
      }

      assert expected_response == response
    end
  end
end
