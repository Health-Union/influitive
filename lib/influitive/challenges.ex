defmodule Influitive.Challenges do
  @moduledoc """
  Documentation for `Influitive.Challenges`.
  """

  @type success_or_error :: {:ok, map()} | {:error, any()}

  alias Influitive.Http

  @doc """
  Get Challenges To Approve
  """
  @spec awaiting_approval() :: success_or_error
  def awaiting_approval() do
    Http.get("approvals")
  end

  @doc """
  Approve/Reject Challenges
  """
  @spec approvals(integer(), String.t(), String.t()) :: success_or_error
  def approvals(challenge_id, decision, feedback \\ "") do
    Http.post("approvals/#{challenge_id}/decision/#{decision}", %{feedback: feedback})
  end

  @doc """
  Archive a challenge identified by the challenge ID
  """
  @spec archive(integer()) :: success_or_error
  def archive(id) do
    Http.post("challenges/#{id}/archive")
  end

  @doc """
  Publish a challenge identified by the challenge ID.
  Optionally schedule the challenge to start and end with the start_at and end_at parameters.

  Params:
    start_at: Challenge publish start (date time) - ISO8601 Format

    end_at: Challenge publish end (date time) - ISO8601 Format

    participant_limit: Number of advocates that can start this challenge
  """
  @spec publish(integer(), map()) :: success_or_error
  def publish(id, params) do
    Http.post("challenges/#{id}/publish", params)
  end

  @doc """
  Unpublish a challenge identified by the challenge ID
  """
  @spec unpublish(integer()) :: success_or_error
  def unpublish(id) do
    Http.post("challenges/#{id}/unpublish")
  end

  @doc """
  This call allows an API user to create a new challenge from a template within the challenge template library.

  Note: To target the challenge to 'Everyone' in your AdvocateHub omit both the 'advocates' and 'group_uuids' arrays entirely from the body of your API call.

  Note: Only use one of the 'advocates' and 'group_uuids' arrays in your API call if not targeting the challenge to 'Everyone' in your AdvocateHub
  """
  @spec create_by_template(map()) :: success_or_error
  def create_by_template(params) do
    Http.post("challenges/create_by_template", params)
  end

  @doc """
  To return details on a given challenge identified by the challenge UUID
  """
  @spec get(String.t()) :: success_or_error
  def get(uuid) do
    Http.get("challenges/#{uuid}/details")
  end

  @doc """
  To return details on a given challenge identified by the challenge UUID
  """
  @spec get_details(String.t()) :: success_or_error
  def get_details(uuid) do
    Http.get("challenges/#{uuid}")
  end
end
