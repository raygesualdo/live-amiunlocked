defmodule Amiunlocked.State do
  use GenServer
  alias Amiunlocked.{KVDB, State}

  @derive Jason.Encoder
  defstruct [:state, :updatedAt]
  @type t :: %__MODULE__{state: String.t(), updatedAt: String.t()}

  # Interface

  @spec read :: Amiunlocked.State.t()
  def read(), do: GenServer.call(__MODULE__, :read)

  @spec write(Amiunlocked.State.t()) :: :ok
  def write(payload), do: GenServer.cast(__MODULE__, {:write, payload})

  @topic inspect(__MODULE__)

  def subscribe() do
    Phoenix.PubSub.subscribe(Amiunlocked.PubSub, @topic)
  end

  # Implementation

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec init(any) :: {:ok, Amiunlocked.State.t()}
  def init(_opts) do
    {:ok, state} = KVDB.read()
    {:ok, state}
  end

  def handle_call(:read, _from, %State{} = val) do
    {:reply, val, val}
  end

  def handle_cast({:write, %State{} = state}, _val) do
    Phoenix.PubSub.broadcast(Amiunlocked.PubSub, @topic, {__MODULE__, state})
    {:noreply, state}
  end
end
