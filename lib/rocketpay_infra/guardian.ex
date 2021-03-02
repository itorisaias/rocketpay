defmodule RocketpayInfra.Guardian do
  use Guardian, otp_app: :rocketpay
  alias Rocketpay.{User, Repo}

  def subject_for_token(user = %User{}, _claims) do
    sub = to_string(user.id)

    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Repo.get(User, id) |> Repo.preload(:account) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
