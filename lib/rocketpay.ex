defmodule Rocketpay do
  alias Rocketpay.Users.Create, as: UserCreate
  alias Rocketpay.Users.Authenticate, as: UserAuthenticate
  alias Rocketpay.Accounts.{Deposit, Transaction, Withdraw}

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate sign_in(params), to: UserAuthenticate, as: :call

  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate transaction(params), to: Transaction, as: :call
end
