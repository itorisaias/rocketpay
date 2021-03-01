defmodule RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller

  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse
  alias Rocketpay.{Account, User}

  action_fallback RocketpayWeb.FallbackController

  def deposit(conn, %{"value" => value}) do
    %User{account: %Account{id: account_id}} = Guardian.Plug.current_resource(conn)

    payload = %{
      "id" => account_id,
      "value" => value
    }

    with {:ok, %Account{} = account} <- Rocketpay.deposit(payload) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def withdraw(conn, params) do
    with {:ok, %Account{} = account} <- Rocketpay.withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def transaction(conn, params) do
    # task = Task.async(fn ->
    #   Rocketpay.transaction(params)
    # end)

    # Task.start(fn -> Rocketpay.transaction(params) end)

    # with {:ok, %TransactionResponse{} = transaction} <- Task.await(task) do
    #   conn
    #   |> put_status(:ok)
    #   |> render("transaction.json", transaction: transaction)
    # end
    with {:ok, %TransactionResponse{} = transaction} <- Rocketpay.transaction(params) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end
end
