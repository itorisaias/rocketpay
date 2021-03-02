defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.Factory
  alias RocketpayInfra.Guardian
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    user = Factory.User.insert(:user)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{
          balance: user.account.balance,
          id: user.account.id
        },
        id: user.id,
        name: user.name,
        nickname: user.nickname
      }
    }

    assert expected_response == response
  end

  test "renders authenticate.json" do
    user = Factory.User.insert(:user)

    {:ok, token, _clains} = Guardian.encode_and_sign(user)

    response = render(UsersView, "authenticate.json", token: token)

    expected_response = %{
      message: "authenticate with success",
      token: token
    }

    assert expected_response == response
  end
end
