defmodule Home.API.V1.RoomController do
  use Home.Web, :controller
  @rooms [
    %{id: "livingroom",
      name: "Living Room",
      lamps_on_scene: "LightScene_10",
      lamps_off_scene: "LightScene_11"},
    %{id: "bedroom",
      name: "Bedroom"}
  ]

  plug :find_room when action in [:show, :command]

  def index(conn, _params) do
    json conn, @rooms
  end

  def show(conn, %{"id" => id}) do
    id_int = String.to_integer(id)
    case Enum.find @rooms, &(Map.get(&1, :id) == id_int) do
      nil ->
        send_resp conn, 404, ""
      room ->
        json conn, room
    end
  end

  def command(conn, params) do
    case params["command"] do
      "lamps_on" ->
        ZWave.activate_scene conn.assigns[:room][:lamps_on_scene]

      "lamps_off" ->
        ZWave.activate_scene conn.assigns[:room][:lamps_off_scene]

      _ ->
        send_resp(conn, 400, "")
    end
  end

  defp find_room(conn, _opts) do
    case Enum.find @rooms, &(Map.get(&1, :id) == conn.params["room_id"]) do
      nil ->
        send_resp(conn, 404, "") |> halt
      room ->
        assign(conn, :room, room)
    end
  end

end
