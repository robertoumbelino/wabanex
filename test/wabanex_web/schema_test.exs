defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do
    test "when a valid id is given, returns the user", %{conn: conn} do
      params = %{email: "beto.umbelino@gmail.com", name: "Roberto", password: "123456"}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
        {
          getUser(id: "#{user_id}") {
            id
            email
            name
          }
        }
      """

      response = 
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      expected_response = %{
        "data" => %{
          "getUser" => %{
            "email" => "beto.umbelino@gmail.com", 
            "id" => user_id, 
            "name" => "Roberto"
          }
        }
      }

      assert response == expected_response
    end
  end

  describe "users mutations" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
            name: "Xpto"
            email: "xpto@gmail.com"
            password: "123456"
          }) {
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
            "id" => _id,
            "name" => "Xpto",
            "email" => "xpto@gmail.com"
          }
        }
      } = response
    end
  end
end