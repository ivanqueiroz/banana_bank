defmodule BananaBank.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias BananaBank.ViaCep.Client

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "sucessfully returns cep info", %{bypass: bypass} do
      cep = "40276140"

      body = ~s({
        "bairro" : "Brotas",
        "cep" : "40276-140",
        "complemento" : "",
        "ddd" : "71",
        "gia" : "",
        "ibge" : "2927408",
        "localidade" : "Salvador",
        "logradouro" : "Vila São Roque",
        "siafi" : "3849",
        "uf" : "BA"
      })

      expected_response =
        {:ok,
         %{
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
         }}

      Bypass.expect(bypass, "GET", "/40276140/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      assert response == expected_response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
