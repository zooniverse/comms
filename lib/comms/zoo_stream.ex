defmodule ZooStream do
  def process(payload) do
    Enum.each(payload, fn event ->
      handle(event["source"], event["type"], event["data"], event["linked"])
    end)
  end

  def handle("panoptes", "classification", data, linked) do
    project_id = data["links"]["project"]

    message = %{
      classification_id: data["id"],
      project_id: data["links"]["project"],
      workflow_id: data["links"]["workflow"],
      user_id: data["links"]["user"],
      subject_ids: data["links"]["subjects"],
      subject_urls: subject_urls(data["links"]["subjects"], linked["subjects"]),
      geo: Geo.locate(data["user_ip"])
    }

    CommsWeb.Endpoint.broadcast("project:#{project_id}", "classification", message)
  end

  def handle(_, _, _, _) do
    nil
  end

  defp subject_urls(ids, subjects) do
    ids = MapSet.new(ids)

    subjects
    |> Enum.filter(fn subject -> MapSet.member?(ids, subject["id"]) end)
    |> Enum.flat_map(fn subject -> subject["locations"] end)
  end
end
