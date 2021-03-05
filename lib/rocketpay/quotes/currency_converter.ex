defmodule Rocketpay.Quotes.CurrencyConverter do
  alias RocketpayInfra.Quotes.AwesomeApi

  def call(params) do
    case params["coin"] do
      nil -> AwesomeApi.fetch_coin()
      coin -> AwesomeApi.fetch_coin(coin)
    end
  end
end
