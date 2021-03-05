defmodule RocketpayWeb.QuotesController do
  use RocketpayWeb, :controller

  alias Rocketpay.Quotes.Coin

  action_fallback RocketpayWeb.FallbackController

  def exchange(conn, params) do
    with {:ok, %Coin{} = coin} <- Rocketpay.exchange(params) do
      conn
      |> put_status(:ok)
      |> render("coin.json", coin: coin)
    end
  end
end
