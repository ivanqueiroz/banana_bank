defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Factory

  setup do
    params = %{
      "name" => "João",
      "cep" => "40276140",
      "email" => "joao@frutas.com",
      "password" => "abc123"
    }

    body = %{
      "bairro" => "Brotas",
      "cep" => "40276-140",
      "complemento" => "",
      "ddd" => "71",
      "gia" => "",
      "ibge" => "2927408",
      "localidade" => "Salvador",
      "logradouro" => "Vila São Roque",
      "siafi" => "3849",
      "uf" => "BA"
    }

    {:ok, %{user_params: params, body: body}}
  end

  describe "create/2" do
    test "succcessfully creates an user", %{conn: conn, user_params: params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "40276140" ->
        {:ok, body}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{"cep" => "40276140", "email" => "joao@frutas.com", "id" => _id, "name" => "João"},
               "message" => "User criado com sucesso"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = %{
        name: nil,
        cep: "12",
        email: "joao@frutas.com",
        password: "abc123"
      }

      expect(BananaBank.ViaCep.ClientMock, :call, fn "12" ->
        {:ok, ""}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      expected_response = %{"errors" => %{"cep" => ["should be 8 character(s)"], "name" => ["can't be blank"]}}

      assert expected_response == response
    end
  end

  describe "delete/2" do
    test "successfully deletes an user", %{conn: conn} do
      user = Factory.insert(:user)

      response =
        conn
        |> delete(~p"/api/users/#{user.id}")
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"cep" => user.cep, "email" => user.email, "id" => user.id, "name" => user.name},
        "message" => "User excluído com sucesso!"
      }

      assert response == expected_response
    end
  end
end
