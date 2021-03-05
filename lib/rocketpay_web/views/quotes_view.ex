defmodule RocketpayWeb.QuotesView do
  alias Rocketpay.Quotes.Coin

  def render("coin.json", %{
        coin: %Coin{
          from: from,
          to: to,
          value: value
        }
      }) do
    %{
      from: from,
      to: to,
      value: value
    }
  end
end
