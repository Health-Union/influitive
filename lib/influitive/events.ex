defmodule Influitive.Events do
  @moduledoc """
  The HTTP interface for interacting with Events endpoint.
  """

  alias Influitive.Http

  @spec list :: {:ok, map()} | {:error, any()}
  def list(params \\ []) do
    Http.get("events", params: params)
  end

  @spec log(map()) :: {:ok, map()} | {:error, any()}
  def log(params) do
    Http.post("events", params)
  end
end
