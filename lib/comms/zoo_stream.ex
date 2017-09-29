defmodule ZooStream do
  def process(payload) do
    Enum.each(payload, fn event ->
      handle(event["source"], event["type"], event["data"], event["linked"])
    end)
  end

  def handle("panoptes", "classification", data, _linked) do
    project_id = data["links"]["project"]

    message = %{
      classification_id: data["id"],
      project_id: data["links"]["project"],
      workflow_id: data["links"]["workflow"],
      user_id: data["links"]["user"],
      subject_ids: [], #subject_ids,
      subject_urls: [], #subject_urls,
      geo: nil #Geo.locate(data["user_ip"])
    }

    CommsWeb.Endpoint.broadcast("projects:#{project_id}", "classification", message)
  end

  def handle(_, _, _, _) do
    nil
  end
end
