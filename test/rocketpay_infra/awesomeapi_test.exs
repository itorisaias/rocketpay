defmodule Rocketpay.AwesomeApiTest do
  use ExUnit.Case

  import Tesla.Mock

  alias Rocketpay.Quotes.Coin
  alias RocketpayInfra.Quotes.AwesomeApi

  describe "fetch_coin/0" do
    setup do
      mock(fn
        %{method: :get, url: "https://economia.awesomeapi.com.br/json/USD-BRL"} ->
          %Tesla.Env{status: 200, body: [%{"ask" => "10.52", "code" => "USD", "codein" => "BRL"}]}
      end)

      :ok
    end

    test "when fetch coin without params return USD-BRL" do
      {:ok, coin} = AwesomeApi.fetch_coin()

      assert %Coin{from: "BRL", to: "USD"} = coin
    end
  end

  describe "fetch_coin/1" do
    setup do
      mock(fn
        %{method: :get, url: "https://economia.awesomeapi.com.br/json/CAD-BRL"} ->
          %Tesla.Env{status: 200, body: [%{"ask" => "10.52", "code" => "CAD", "codein" => "BRL"}]}

        %{method: :get, url: "https://economia.awesomeapi.com.br/json/XXX-BRL"} ->
          %Tesla.Env{status: 404, body: %{}}
      end)

      :ok
    end

    test "when fetch coin CAD return coin" do
      {:ok, coin} = AwesomeApi.fetch_coin("CAD")

      assert %Coin{from: "BRL", to: "CAD"} = coin
    end

    test "when fetch a coin that doesn't exist, return error" do
      {:error, error} = AwesomeApi.fetch_coin("XXX")

      assert error == "coin not found"
    end
  end

  describe "fetch_coin/2" do
    setup do
      mock(fn
        %{method: :get, url: "https://economia.awesomeapi.com.br/json/CAD-USD"} ->
          %Tesla.Env{status: 200, body: [%{"ask" => "10.52", "code" => "CAD", "codein" => "USD"}]}

        %{method: :get, url: "https://economia.awesomeapi.com.br/json/USD-CAD"} ->
          %Tesla.Env{status: 200, body: [%{"ask" => "10.52", "code" => "USD", "codein" => "CAD"}]}

        %{method: :get, url: "https://economia.awesomeapi.com.br/json/USD-XXX"} ->
          %Tesla.Env{status: 404, body: %{}}
      end)

      :ok
    end

    test "when fetch coin CAD-USD return coin" do
      {:ok, coin} = AwesomeApi.fetch_coin("CAD", "USD")

      assert %Coin{from: "USD", to: "CAD"} = coin
    end

    test "when fetch coin USD-CAD return coin" do
      {:ok, coin} = AwesomeApi.fetch_coin("USD", "CAD")

      assert %Coin{to: "USD", from: "CAD"} = coin
    end

    test "when fetch a coin and one of them doesn't exist, return error" do
      {:error, error} = AwesomeApi.fetch_coin("USD", "XXX")

      assert error == "coin not found"
    end
  end
end
