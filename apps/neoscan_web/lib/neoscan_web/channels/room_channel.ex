defmodule NeoscanWeb.RoomChannel do
  @moduledoc false
  use Phoenix.Channel
  alias NeoscanMonitor.Api
  alias NeoscanWeb.Endpoint

  def join("room:home", _payload, socket) do
    {
      :ok,
      %{:blocks => Api.get_blocks, :transactions => Api.get_transactions},
      socket
    }
  end

  def broadcast_change(state) do
    payload = %{
      "blocks" => state.blocks,
      "transactions" => state.transactions,
    }

    Endpoint.broadcast("room:home", "change", payload)
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end
