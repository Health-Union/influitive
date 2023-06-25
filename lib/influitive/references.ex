defmodule Influitive.References do
  @moduledoc """
  Documentation for `Influitive.References`.
  """

  @type success_or_error :: {:ok, map()} | {:error, any()}

  alias Influitive.Http

  @doc """
  Create/Update/Complete Reference Challenges

  Note: Members/Advocates is an array of the people to whom you would like to target this challenge. If provided you must supply either a salesforce id, the email of the member, or an Influitive ID.

  Note: Prospect/Account is the person, company, account etc. that this reference is for. To accurately track references, passing an external_id or email will match these requests with existing prospects in our system. Omitting these values will create NEW challenges for every request.

  Note: Please use only account OR prospect and member OR advocates
  """
  @spec create_or_update(map()) :: success_or_error
  def create_or_update(params) do
    Http.post("references", params)
  end

  @doc """
  Log Reference Type Events
  """
  @spec log_events(map()) :: success_or_error
  def log_events(params) do
    Http.post("references/events", params)
  end

  @doc """
  Get Reference Completions
  """
  @spec completions(String.t()) :: success_or_error
  def completions(cursor \\ "") do
    Http.get("references", params: %{cursor: cursor})
  end
end
