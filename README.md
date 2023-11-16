# influitive_ex

A wrapper around the Influitive API

## Installation

The package can be installed by adding `influitive` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:influitive, "~> 0.1.2"}
  ]
end
```

[HexDocs](https://hexdocs.pm/influitive)


## Configuration

Put your API key and Org ID in your `config.exs` file:

```elixir
config :influitive,
  api_key: "myApiKey",
  org_id: "myOrgId"
```

You can customize the json library to use another library via the `:json_library` configuration:

```elixir
config :influitive, :json_library, SomeOtherLib
```
