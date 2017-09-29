defmodule Comms.ZooStream.PanoptesClassification do
  defstruct [:classification_id, :project_id, :workflow_id, :user_id, :subject_ids, :subject_urls, :geo]

  def from(data, linked) do
    %__MODULE__{
      classification_id: data["id"],
      project_id: data["links"]["project"],
      workflow_id: data["links"]["workflow"],
      user_id: data["links"]["user"],
      subject_ids: data["links"]["subjects"],
      subject_urls: subject_urls(data["links"]["subjects"], linked["subjects"]),
      geo: Geo.locate(data["user_ip"])
    }
  end

  defp subject_urls(ids, subjects) do
    ids = MapSet.new(ids)

    subjects
    |> Enum.filter(fn subject -> MapSet.member?(ids, subject["id"]) end)
    |> Enum.flat_map(fn subject -> subject["locations"] end)
  end
end
