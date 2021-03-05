defmodule RocketpayInfra.Quotes.AwesomeApi do
  use Tesla
  alias Rocketpay.Quotes.Coin
  alias RocketpayInfra.CachexCache

  plug Tesla.Middleware.BaseUrl, "https://economia.awesomeapi.com.br"
  plug Tesla.Middleware.Logger
  plug Tesla.Middleware.JSON

  def fetch_coin(coin_to \\ "USD", coin_from \\ "BRL") do
    case CachexCache.get(gen_key(coin_from, coin_to)) do
      nil ->
        "/json/#{coin_to}-#{coin_from}"
        |> get()
        |> handle_response()
        |> handle_cast()
        |> handle_cache()

      coin ->
        {:ok, coin}
    end
  end

  defp handle_response({:error, error}), do: {:error, error}

  defp handle_response({:ok, %Tesla.Env{status: status}})
       when status == 404,
       do: {:error, "coin not found"}

  defp handle_response({:ok, %Tesla.Env{body: body, status: status}})
       when status == 200,
       do: {:ok, List.first(body)}

  defp handle_cast({:error, error}), do: {:error, error}

  defp handle_cast({:ok, %{"ask" => value, "code" => to, "codein" => from}}) do
    {:ok,
     %Coin{
       from: from,
       to: to,
       value: value
     }}
  end

  defp handle_cache({:error, error}), do: {:error, error}

  defp handle_cache({:ok, %Coin{from: from, to: to} = coin}) do
    gen_key(from, to)
    |> CachexCache.set(coin, ttl: :timer.hours(1))

    {:ok, coin}
  end

  defp gen_key(from, to), do: String.to_atom("awesomeapi_#{from}_#{to}")
end
