defmodule Rocketpay.Factory.User do
  use ExMachina.Ecto, repo: Rocketpay.Repo
  alias Rocketpay.{Account, User}

  def user_request_factory do
    %{
      "name" => "Jane Smith",
      "email" => sequence(:email, &"email-#{&1}@example.com"),
      "nickname" => sequence(:nickname, &"nickname-#{&1}"),
      "age" => Enum.random(18..70),
      "password" => "123456"
    }
  end

  def user_factory do
    password = Faker.String.base64()

    %User{
      id: Ecto.UUID.generate(),
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      nickname: Faker.Internet.user_name(),
      age: Enum.random(18..70),
      password: password,
      password_hash: Argon2.hash_pwd_salt(password),
      account: %Account{
        balance: Faker.random_between(18, 22) |> Integer.to_string() |> Decimal.new(),
        id: Ecto.UUID.generate()
      }
    }
  end
end
