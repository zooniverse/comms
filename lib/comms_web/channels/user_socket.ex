defmodule CommsWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", CommsWeb.RoomChannel
  channel "zooniverse", CommsWeb.ZooniverseChannel
  channel "project:*", CommsWeb.ProjectChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket) do
    if params["token"] do
      token = AuthToken.read(params["token"])

      user_id = token.claims["data"]["id"]
      user_login = token.claims["data"]["login"]
      is_admin = token.claims["data"]["admin"]

      assigns = socket
      |> assign(:user_id, user_id)
      |> assign(:user_login, user_login)
      |> assign(:is_admin, is_admin)

      {:ok, assigns}
    else
      assigns = socket
      |> assign(:user_id, nil)
      |> assign(:user_login, nil)
      |> assign(:is_admin, nil)

      {:ok, assigns}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     CommsWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
