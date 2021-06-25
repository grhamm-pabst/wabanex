defmodule Wabanex.UserTest do
  use Wabanex.DataCase, async: true

  alias Ecto.Changeset
  alias Wabanex.User

  describe "changeset/1" do
    test "when all params are valid, returns the user" do
      params = %{name: "Grhamm", email: "grhamm@banana.com", password: "123456"}

      response = User.changeset(params)

      assert %Changeset{
               valid?: true,
               changes: %{name: "Grhamm", email: "grhamm@banana.com", password: "123456"}
             } = response
    end

    test "when there are errors, returns a invalid changeset" do
      params = %{name: "G", email: "grhamm", password: "123"}

      response = User.changeset(params)

      expected_response = %{
        email: ["has invalid format"],
        name: ["should be at least 2 character(s)"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
