defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias RocketpayInfra.Guardian
  alias Rocketpay.Factory

  describe "deposit/2" do
    setup %{conn: conn} do
      user = Factory.User.insert(:user)

      {:ok, token, _clains} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, account_id: user.account.id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "50.00", "id" => ^account_id},
               "message" => "balance changed successfully"
             } = response
    end

    test "when there are invalid params, returns errors", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expect_response = %{"message" => "invalid deposit value!"}

      assert expect_response == response
    end
  end

  describe "withdraw/v2" do
    setup %{conn: conn} do
      user = Factory.User.insert(:user)

      Rocketpay.deposit(%{"id" => user.account.id, "value" => "50.0"})

      {:ok, token, _clains} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, account_id: user.account.id}
    end

    test "when all params are valid, make the withdraw", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "0.00", "id" => ^account_id},
               "message" => "balance changed successfully"
             } = response
    end

    test "when there are invalid params, returns errors", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

      expect_response = %{"message" => "invalid withdraw value!"}

      assert expect_response == response
    end
  end

  describe "transaction/v2" do
    setup %{conn: conn} do
      user_from = Factory.User.insert(:user)
      user_to = Factory.User.insert(:user)

      Rocketpay.deposit(%{"id" => user_from.account.id, "value" => "50.0"})

      {:ok, token, _clains} = Guardian.encode_and_sign(user_from)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, from_account_id: user_from.account.id, to_account_id: user_to.account.id}
    end

    test "when are params valid, make the transaction", %{
      conn: conn,
      from_account_id: from_account_id,
      to_account_id: to_account_id
    } do
      params = %{
        "from_account" => from_account_id,
        "to_account" => to_account_id,
        "value" => "1"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, params))
        |> json_response(:ok)

      assert %{
               "message" => "Transaction done successfully",
               "transaction" => %{
                 "from_account" => %{
                   "balance" => "49.0",
                   "id" => ^from_account_id
                 },
                 "to_account" => %{
                   "balance" => "1.0",
                   "id" => ^to_account_id
                 }
               }
             } = response
    end
  end
end
