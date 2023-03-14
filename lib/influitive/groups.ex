defmodule Influitive.Groups do
  @moduledoc """
  The HTTP interface for interacting with Groups endpoint.
  """

  alias Influitive.Http

  @spec members(String.t()) :: {:ok, map()} | {:error, any()}
  def members(group_uuid) do
    Http.get("groups/#{group_uuid}/members")
  end
end
