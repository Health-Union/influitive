defmodule Influitive.Referrals do
  @moduledoc """
  Documentation for `Influitive.Referrals`.
  """

  @type success_or_error :: {:ok, map()} | {:error, any()}

  alias Influitive.Http

  @doc """
  Create a Referral
  """
  @spec create(map()) :: success_or_error
  def create(params) do
    Http.post("referrals", params)
  end

  @doc """
  Advancing a Referral
  """
  @spec advance(String.t(), String.t(), String.t()) :: success_or_error
  def advance(referral_id, milestone, feedback \\ "") do
    Http.put("referrals/#{referral_id}/milestones/#{milestone}", %{feedback: feedback})
  end

  @doc """
  Retrieve All Referrals
  """
  @spec list(map()) :: success_or_error
  def list(query_params \\ []) do
    Http.get("referrals", params: query_params)
  end

  @doc """
  Retrieve Referral By ID
  """
  @spec get(String.t()) :: success_or_error
  def get(id) do
    Http.get("referrals/#{id}")
  end
end
