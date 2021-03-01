defmodule Rocketpay.Users.AuthenticateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.{Create, Authenticate}

  describe "call/1" do
    test "when password valid, return user" do
      params = %{
        name: "itor",
        password: "123456",
        nickname: "itor.isaias",
        email: "itor.isaias@gmail.com",
        age: 22
      }

      {:ok, %User{id: user_id}} = Create.call(params)

      {:ok, user} =
        %{"email" => params.email, "password" => params.password} |> Authenticate.call()

      assert %User{name: "itor", age: 22, id: ^user_id} = user
    end

    test "when password invalid, return error" do
      params = %{
        name: "itor",
        password: "123456",
        nickname: "itor.isaias",
        email: "itor.isaias@gmail.com",
        age: 22
      }

      Create.call(params)

      {:error, reason} =
        %{"email" => params.email, "password" => "invalid_password"}
        |> Authenticate.call()

      assert reason == :invalid_credentials
    end

    test "when email no exist, return error" do
      params = %{
        name: "itor",
        password: "123456",
        nickname: "itor.isaias",
        email: "itor.isaias@gmail.com",
        age: 22
      }

      Create.call(params)

      {:error, reason} =
        %{"email" => "not_found@gmail.com", "password" => params.password}
        |> Authenticate.call()

      assert reason == :invalid_credentials
    end
  end
end
