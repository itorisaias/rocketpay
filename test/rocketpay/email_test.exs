defmodule Rocketpay.EmailTest do
  use ExUnit.Case

  import Rocketpay.Factory.User

  test "welcome_email/1" do
    user = build(:user)

    email = Rocketpay.Email.welcome_email(user)

    assert email.to == {user.name, user.email}
    assert email.from == {"RocketPay", "contato@rocketpay.com.br"}
    assert email.subject == "Bem vindo ao Rocketpay!"
  end
end
