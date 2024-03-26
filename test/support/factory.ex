defmodule BananaBank.Factory do
  use ExMachina.Ecto, repo: BananaBank.Repo

  def user_factory do
    %BananaBank.Users.User{
      name: "John Doe",
      email: sequence(:email, &"email-#{&1}@test.com"),
      password: sequence(:password, &"password-#{&1}"),
      password_hash: sequence(:password, &"password-#{&1}"),
      cep: sequence(:cep, &"0123456#{&1}")
    }
  end
end
