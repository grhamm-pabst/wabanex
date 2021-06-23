defmodule Wabanex.Error do
  @keys [:status, :reason]

  @enforce_keys @keys

  defstruct @keys

  def build(status, reason) do
    %__MODULE__{
      status: status,
      reason: reason
    }
  end
end
