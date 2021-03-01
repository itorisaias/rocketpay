defmodule Rocketpay.Users.Authenticate do
  alias Rocketpay.{Repo, User}

  def call(%{"email" => email, "password" => password}) do
    Repo.get_by(User, email: email)
    |> verify_password(password)
  end

  defp verify_password(nil, _password) do
    Argon2.no_user_verify()

    {:error, :invalid_credentials}
  end

  defp verify_password(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end
end
