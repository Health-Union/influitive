defmodule Influitive.Rewards do
  @moduledoc """
  Documentation for `Influitive.Rewards`.
  """

  @type success_or_error :: {:ok, map()} | {:error, any()}
  @type id_or_uuid :: integer() | String.t()

  alias Influitive.Http

  @doc """
  To retrieve details on all rewards in your AdvcateHub
  """
  @spec list :: success_or_error
  def list do
    Http.get("external/rewards")
  end

  @doc """
  Retrieve reward redemptions that require fulfillment or refusal.
  """
  @spec reward_redemptions :: success_or_error
  def reward_redemptions do
    Http.get("reward_redemptions")
  end

  @doc """
  Fulfill Reward Redemption
  """
  @spec fulfill(id_or_uuid, map()) :: success_or_error
  def fulfill(id_or_uuid, params) do
    Http.post("reward_redemptions/#{id_or_uuid}/decision/fulfill", params)
  end

  @doc """
  Refuse Reward Redemption
  """
  @spec refuse(id_or_uuid, map()) :: success_or_error
  def refuse(id_or_uuid, params) do
    Http.post("reward_redemptions/#{id_or_uuid}/decision/refuse", params)
  end

  @doc """
  Publish a reward based on the reward ID
  """
  @spec publish(id_or_uuid) :: success_or_error
  def publish(id_or_uuid) do
    Http.post("external/rewards/#{id_or_uuid}/publish")
  end

  @doc """
  Unpublish a reward based on the reward ID
  """
  @spec unpublish(id_or_uuid) :: success_or_error
  def unpublish(id_or_uuid) do
    Http.post("external/rewards/#{id_or_uuid}/unpublish")
  end
end
