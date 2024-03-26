defmodule BananaBankWeb.UsersJSON do
  alias BananaBank.Users.User

  def create(%{user: user}) do
    %{
      message: "User criado com sucesso",
      data: data(user)
    }
  end

  def get(%{user: user}), do: %{data: data(user)}

  def delete(%{user: user}), do: %{message: "User excluído com sucesso!", data: data(user)}

  def update(%{user: user}), do: %{message: "User atualizado com sucesso!", data: data(user)}

  def login(%{token: token}), do: %{message: "User autenticado com sucesso!", bearer: token}

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      cep: user.cep,
      email: user.email
    }
  end
end
