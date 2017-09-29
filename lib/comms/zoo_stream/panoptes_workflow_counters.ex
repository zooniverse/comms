defmodule Comms.ZooStream.PanoptesWorkflowCounters do
  defstruct [:project_id, :workflow_id, :classifications_count, :subjects_count, :retired_subjects_count]

  def from(data, linked) do
    %__MODULE__{
      project_id: data["project_id"],
      workflow_id: data["workflow_id"],
      classifications_count: data["classifications_count"],
      subjects_count: data["subjects_count"],
      retired_subjects_count: data["retired_subjects_count"]
    }
  end
end
