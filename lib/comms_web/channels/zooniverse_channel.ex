defmodule CommsWeb.ZooniverseChannel do
  use CommsWeb, :channel
  alias CommsWeb.Presence

  def join("zooniverse", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (project:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", CommsWeb.Presence.list(socket)
    {:ok, _} = CommsWeb.Presence.track(socket, socket.assigns.user_id, %{
          online_at: inspect(System.system_time(:seconds))
                              })
    {:noreply, socket}
  end

  defp authorized?(_payload) do
    true
  end
end