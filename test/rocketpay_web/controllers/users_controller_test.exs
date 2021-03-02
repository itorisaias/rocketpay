defmodule RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Factory, User}

  describe "create/2" do
    test "when all params are valid, create user", %{conn: conn} do
      params = Factory.User.build(:user_request)
      %{"name" => name, "nickname" => nickname} = params

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created",
               "user" => %{
                 "account" => %{
                   "balance" => "0.00"
                 },
                 "name" => ^name,
                 "nickname" => ^nickname
               }
             } = response
    end

    test "when trying to create a user with an existing email, return error", %{conn: conn} do
      %User{email: email} = Factory.User.insert(:user)

      params = Factory.User.build(:user_request, %{"email" => email})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expect_response = %{"message" => %{"email" => ["has already been taken"]}}

      assert expect_response == response
    end

    test "when trying to create a user with an existing nickname, return error", %{conn: conn} do
      %User{nickname: nickname} = Factory.User.insert(:user)

      params = Factory.User.build(:user_request, %{"nickname" => nickname})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expect_response = %{"message" => %{"nickname" => ["has already been taken"]}}

      assert expect_response == response
    end

    test "when the password is less than, return error", %{conn: conn} do
      params = Factory.User.build(:user_request, %{"password" => "12345"})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expect_response = %{"message" => %{"password" => ["should be at least 6 character(s)"]}}

      assert expect_response == response
    end
  end

  describe "sign_in/2" do
    test "when all params are valid, return a token", %{conn: conn} do
      %User{email: email, password: password} = Factory.User.insert(:user)

      params = %{"email" => email, "password" => password}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:ok)

      assert %{"message" => "authenticate with success", "token" => _token} = response
    end

    test "when there are params invalid, return error", %{conn: conn} do
      %User{email: email} = Factory.User.insert(:user)

      params = %{"email" => email, "password" => "invalid_password"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:bad_request)

      assert %{"message" => "invalid_credentials"} = response
    end

    test "when email not found, return error", %{conn: conn} do
      params = %{"email" => "email_not_found@examplo.com", "password" => "123456"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:bad_request)

      assert %{"message" => "invalid_credentials"} = response
    end
  end
end
