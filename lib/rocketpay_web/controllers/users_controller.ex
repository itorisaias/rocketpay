defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User
  alias RocketpayInfra.Guardian

  action_fallback(RocketpayWeb.FallbackController)

  def create(conn, params) do
    with {:ok, %User{} = user} <- Rocketpay.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  def sign_in(conn, params) do
    with {:ok, user} <- Rocketpay.sign_in(params) do
      {:ok, token, _clains} = Guardian.encode_and_sign(user)

      conn
      |> put_status(:ok)
      |> render("authenticate.json", token: token)
    end
  end
end
