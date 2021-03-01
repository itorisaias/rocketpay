defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias RocketpayInfra.Guardian
  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "itor",
        password: "123456",
        nickname: "itor.isaias",
        email: "itor.isaias@gmail.com",
        age: 22
      }

      {:ok, %User{account: %Account{id: account_id}} = user} = Rocketpay.create_user(user_params)

      {:ok, token, _clains} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, account_id: account_id}
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
      user_params = %{
        name: "itor",
        password: "123456",
        nickname: "itor.isaias",
        email: "itor.isaias@gmail.com",
        age: 22
      }

      {:ok, %User{account: %Account{id: account_id}} = user} = Rocketpay.create_user(user_params)
      Rocketpay.deposit(%{"id" => account_id, "value" => "50.0"})

      {:ok, token, _clains} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, account_id: account_id}
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
      {:ok, %User{account: %Account{id: from_account_id}} = user_1} =
        Rocketpay.create_user(%{
          name: "itor 1",
          password: "123456",
          nickname: "itor.isaias.1",
          email: "itor.isaias.1@gmail.com",
          age: 22
        })

      Rocketpay.deposit(%{"id" => from_account_id, "value" => "50.0"})

      {:ok, %User{account: %Account{id: to_account_id}}} =
        Rocketpay.create_user(%{
          name: "itor 2",
          password: "123456",
          nickname: "itor.isaias.2",
          email: "itor.isaias.2@gmail.com",
          age: 22
        })

      {:ok, token, _clains} = Guardian.encode_and_sign(user_1)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, from_account_id: from_account_id, to_account_id: to_account_id}
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
                   "balance" => "49.00",
                   "id" => ^from_account_id
                 },
                 "to_account" => %{
                   "balance" => "1.00",
                   "id" => ^to_account_id
                 }
               }
             } = response
    end
  end
end
