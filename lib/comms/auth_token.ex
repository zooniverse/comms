defmodule AuthToken do
  import Joken

  def read(token) do
    key = JOSE.JWK.from_pem_file("doorkeeper-jwt-staging.pub")

    token
    |> Joken.token
    |> with_signer(rs512(key))
    |> verify
  end
end
