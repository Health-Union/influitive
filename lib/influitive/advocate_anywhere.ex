defmodule Influitive.AdvocateAnywhere do
  @moduledoc """
  Documentation for `Influitive.Referrals`.
  """

  @type success_or_error :: {:ok, map()} | {:error, any()}

  alias Influitive.Http

  @doc """
  Calling AdvocateAnywhere Directly
  Utilize AdvocateAnywhere APIs directly to customimze the experience for your advocates.
  """
  @spec challenges(map()) :: success_or_error
  def challenges(query_params) do
    Http.get("embedded/challenges", [params: query_params])
  end

  @doc """
  Identifying an Advocate
  """
  @spec identify(map()) :: success_or_error
  def identify(query_params) do
    Http.get("embedded/contacts/identify", [params: query_params])
  end

  @doc """
  Submitting Challenges
  """
  @spec submit_challenges(map()) :: success_or_error
  def submit_challenges(query_params) do
    Http.get("embedded/challenges", [params: query_params])
  end
end
