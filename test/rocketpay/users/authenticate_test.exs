defmodule Rocketpay.Users.AuthenticateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{Factory, User}
  alias Rocketpay.Users.{Authenticate, Create}

  describe "call/1" do
    test "when password valid, return user" do
      %User{email: email, password: password, id: user_id} = Factory.User.insert(:user)

      {:ok, user} = %{"email" => email, "password" => password} |> Authenticate.call()

      assert %User{id: ^user_id} = user
    end

    test "when password invalid, return error" do
      %User{email: email} = Factory.User.insert(:user)

      {:error, reason} =
        %{"email" => email, "password" => "invalid_password"}
        |> Authenticate.call()

      assert reason == :invalid_credentials
    end

    test "when email no exist, return error" do
      {:error, reason} =
        %{"email" => "user_not_found@email.com", "password" => "123456"}
        |> Authenticate.call()

      assert reason == :invalid_credentials
    end
  end
end
