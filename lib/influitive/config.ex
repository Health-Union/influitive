defmodule Influitive.Config do
  @moduledoc """
  Configuration helper.
  """

  @default_api_endpoint "https://api.influitive.com"

  @spec api_key() :: String.t()
  def api_key do
    Application.get_env(
      :influitive,
      :api_key
    )
  end

  @spec org_id() :: String.t()
  def org_id do
    Application.get_env(
      :influitive,
      :org_id
    )
  end

  @spec api_endpoint :: String.t()
  def api_endpoint do
    Application.get_env(
      :influitive,
      :api_endpoint,
      @default_api_endpoint
    )
  end

  def json_library do
    Application.get_env(:influitive, :json_library, Jason)
  end
end
