defmodule Rocketpay do
  alias Rocketpay.Accounts.{Deposit, Transaction, Withdraw}
  alias Rocketpay.Quotes.CurrencyConverter
  alias Rocketpay.Users.Authenticate, as: UserAuthenticate
  alias Rocketpay.Users.Create, as: UserCreate

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate sign_in(params), to: UserAuthenticate, as: :call

  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate transaction(params), to: Transaction, as: :call

  defdelegate exchange(params), to: CurrencyConverter, as: :call
end
