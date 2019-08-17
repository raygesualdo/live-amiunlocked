defmodule AmiunlockedWeb.StateChannel do
  use AmiunlockedWeb, :channel
  alias Amiunlocked.State

  def join("state", _payload, socket) do
    state = State.read()

    {:ok, state, socket}
  end
end
