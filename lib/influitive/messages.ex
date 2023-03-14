defmodule Influitive.Messages do
  @moduledoc """
  Documentation for `Influitive.Messages`.
  """

  @type success_or_error :: {:ok, map()} | {:error, any()}

  alias Influitive.Http

  @doc """
  Send a message to an Advocate from a specified Administrator
  """
  @spec send(String.t(), String.t(), String.t()) :: success_or_error
  def send(message, sender_uuid, recipient_uuid) do
    Http.post("messages/send", %{message: message, sender_uuid: sender_uuid, recipient_uuid: recipient_uuid})
  end
end
