defmodule CommsWeb.UserChannel do
  use CommsWeb, :channel

  def join("user:" <> user_id, payload, socket) do
    if authorized?(user_id, payload) do
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

  defp authorized?(user_id, payload) do
    true
  end
end
