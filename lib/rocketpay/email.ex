defmodule Rocketpay.Email do
  use Bamboo.Template,
    view: RocketpayWeb.Email.UserView

  import Bamboo.Email
  alias Rocketpay.User

  def welcome_email(%User{name: name, email: email} = user) do
    new_email()
    |> from({"RocketPay", "contato@rocketpay.com.br"})
    |> to({name, email})
    |> subject("Bem vindo ao Rocketpay!")
    |> assign(:user, user)
    |> put_html_layout({RocketpayWeb.Email.LayoutView, "email.html"})
    |> render(:welcome_email)
  end
end
