defmodule ZooStream do
  def process(payload) do
    Enum.each(payload, fn event ->
      handle(event["source"], event["type"], event["data"], event["linked"])
    end)
  end

  def handle("panoptes", "classification", data, linked) do
    message = Comms.ZooStream.PanoptesClassification.from(data, linked)
    CommsWeb.Endpoint.broadcast("project:#{message.project_id}", "classification", message)
  end

  def handle("panoptes", "workflow_counters", data, linked) do
    message = Comms.ZooStream.PanoptesWorkflowCounters.from(data, linked)
    CommsWeb.Endpoint.broadcast("project:#{message.project_id}", "workflow_counters", message)
  end

  def handle(_, _, _, _) do
    nil
  end
end
