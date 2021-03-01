defmodule RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "create/2" do
    test "when all params are valid, create user", %{conn: conn} do
      params = %{
        "age" => 18,
        "email" => "itorzin@gmail.com",
        "name" => "Itor Isais da Silva",
        "nickname" => "itorzin",
        "password" => "123456"
      }

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
                 "name" => "Itor Isais da Silva",
                 "nickname" => "itorzin"
               }
             } = response
    end

    test "when trying to create a user with an existing email, return error", %{conn: conn} do
      {:ok, _user} =
        Rocketpay.create_user(%{
          age: 18,
          email: "itorisaias@gmail.com",
          name: "Itor Isais da Silva",
          nickname: "itorisaias",
          password: "123456"
        })

      params = %{
        "age" => 25,
        "email" => "itorisaias@gmail.com",
        "name" => "Itor Isaias",
        "nickname" => "itor.isaias",
        "password" => "123456"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expect_response = %{"message" => %{"email" => ["has already been taken"]}}

      assert expect_response == response
    end

    test "when trying to create a user with an existing nickname, return error", %{conn: conn} do
      {:ok, _user} =
        Rocketpay.create_user(%{
          age: 18,
          email: "itorisaias@gmail.com",
          name: "Itor Isais da Silva",
          nickname: "itorisaias",
          password: "123456"
        })

      params = %{
        "age" => 25,
        "email" => "itor.isaias.outro@gmail.com",
        "name" => "Itor Isaias",
        "nickname" => "itorisaias",
        "password" => "123456"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expect_response = %{"message" => %{"nickname" => ["has already been taken"]}}

      assert expect_response == response
    end

    test "when the password is less than, return error", %{conn: conn} do
      params = %{
        "age" => 25,
        "email" => "itor.isaias.outro@gmail.com",
        "name" => "Itor Isaias",
        "nickname" => "itorisaias",
        "password" => "12345"
      }

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
      {:ok, _user} =
        Rocketpay.create_user(%{
          "age" => 18,
          "email" => "itorzin@gmail.com",
          "name" => "Itor Isais da Silva",
          "nickname" => "itorzin",
          "password" => "123456"
        })

      params = %{
        "email" => "itorzin@gmail.com",
        "password" => "123456"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:ok)

      assert %{"message" => "authenticate with success", "token" => _token} = response
    end

    test "when there are params invalid, return error", %{conn: conn} do
      {:ok, _user} =
        Rocketpay.create_user(%{
          "age" => 18,
          "email" => "itorzin@gmail.com",
          "name" => "Itor Isais da Silva",
          "nickname" => "itorzin",
          "password" => "123456"
        })

      params = %{
        "email" => "itorzin@gmail.com",
        "password" => "invalid_password"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:bad_request)

      assert %{"message" => "invalid_credentials"} = response
    end

    test "when email not found, return error", %{conn: conn} do
      {:ok, _user} =
        Rocketpay.create_user(%{
          "age" => 18,
          "email" => "itorzin@gmail.com",
          "name" => "Itor Isais da Silva",
          "nickname" => "itorzin",
          "password" => "123456"
        })

      params = %{
        "email" => "itor.naoexiste@gmail.com",
        "password" => "123456"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:bad_request)

      assert %{"message" => "invalid_credentials"} = response
    end
  end
end
