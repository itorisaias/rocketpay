alias Rocketpay.{Repo, User, Account}

%{id: user_id} = User.changeset(%{
  "name" => "Itor Isaias",
  "age" => "24",
  "email" => "itor.isaias@gmail.com",
  "password" => "123456",
  "nickname" => "itor.isaias",
})
|> Repo.insert!()

Account.changeset(%Account{}, %{
  user_id: user_id,
  balance: "50.0"
})
|> Repo.insert!()
