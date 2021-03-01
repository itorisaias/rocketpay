defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias RocketpayInfra.Guardian
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    user_params = %{
      name: "itor",
      password: "123456",
      nickname: "itor.isaias",
      email: "itor.isaias@gmail.com",
      age: 22
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(user_params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id
        },
        id: user_id,
        name: "itor",
        nickname: "itor.isaias"
      }
    }

    assert expected_response == response
  end

  test "renders authenticate.json" do
    {:ok, user} = Rocketpay.create_user(%{
      name: "itor",
      password: "123456",
      nickname: "itor.isaias",
      email: "itor.isaias@gmail.com",
      age: 22
    })
    {:ok, token, _clains} = Guardian.encode_and_sign(user)

    response = render(UsersView, "authenticate.json", token: token)

    expected_response = %{
      message: "authenticate with success",
      token: token
    }

    assert expected_response == response
  end
end
