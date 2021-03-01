defmodule Rocketpay.EmailTest do
  use ExUnit.Case
  alias Rocketpay.User

  test "welcome_email/1" do
    user = %User{name: "itor", email: "itor.isaias@gmail.com"}

    email = Rocketpay.Email.welcome_email(user)

    assert email.to == {"itor", "itor.isaias@gmail.com"}
    assert email.from == {"RocketPay", "contato@rocketpay.com.br"}
    assert email.subject == "Bem vindo ao Rocketpay!"
  end
end
