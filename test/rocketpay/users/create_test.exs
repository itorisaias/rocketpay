defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true
  use Bamboo.Test

  alias Rocketpay.{Repo, User}
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "itor",
        password: "123456",
        nickname: "itor.isaias",
        email: "itor.isaias@gmail.com",
        age: 22
      }

      {:ok, %User{id: user_id}} = Create.call(params)

      user = Repo.get(User, user_id)

      assert %User{name: "itor", age: 22, id: ^user_id} = user
    end

    test "when there are invalid params, returns an error" do
      invalid_params = %{
        name: "itor",
        nickname: "itor.isaias",
        email: "itor.isaias@gmail.com",
        age: 15
      }

      {:error, changeset} = Create.call(invalid_params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end

    test "after registering, the user get a welcome email" do
      params = %{
        name: "itor",
        password: "123456",
        nickname: "itor.isaias",
        email: "itor.isaias@gmail.com",
        age: 24
      }

      {:ok, user} = Create.call(params)

      expected_email = Rocketpay.Email.welcome_email(user)

      assert_delivered_email expected_email
    end
  end
end
