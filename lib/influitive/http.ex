defmodule Influitive.Http do
  @moduledoc """
  The HTTP interface for interacting with the Influitive API.
  """

  alias Influitive.Config

  @spec delete(String.t()) :: {:ok, any()} | {:error, any()}
  def delete(url_path) do
    request(:delete, url_path)
  end

  @spec post(String.t(), any()) :: {:ok, any()} | {:error, any()}
  def post(url_path, body \\ "") do
    request(:post, url_path, body)
  end

  @spec put(String.t(), any()) :: {:ok, any()} | {:error, any()}
  def put(url_path, body) do
    request(:put, url_path, body)
  end

  @spec patch(String.t(), any()) :: {:ok, any()} | {:error, any()}
  def patch(url_path, body) do
    request(:patch, url_path, body)
  end

  @spec get(String.t(), any()) :: {:ok, any()} | {:error, any()}
  def get(url_path, options \\ []) do
    request(:get, url_path, "", options)
  end

  def headers do
    ["Authorization": "Token #{Config.api_key}", "X_ORG_ID": Config.org_id]
  end

  defp request(method, url_path, body \\ "", options \\ []) do
    url = build_url(url_path)
    body = encode_body(body)

    method
    |> HTTPoison.request(url, body, headers(), options)
    |> parse_response()
  end

  defp encode_body(body) when is_map(body) do
    Config.json_library().encode!(body)
  end

  defp encode_body(body), do: body

  defp parse_response({:ok, %{body: body}}) do
    if body === "" do
      body
    else
      Config.json_library().decode(body)
    end
  end

  defp build_url(url_path) do
    Config.api_endpoint()
    |> URI.merge(url_path)
  end
end
