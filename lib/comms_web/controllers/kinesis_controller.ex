defmodule CommsWeb.KinesisController do
  use CommsWeb, :controller

  def create(conn, params) do
    ZooStream.process(params["payload"])
    text conn, "{}"
  end
end
