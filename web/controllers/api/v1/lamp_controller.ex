defmodule Home.API.V1.LampController do
  use Home.Web, :controller
  require Logger

  @lamps [
      %{id: 1},
      %{id: 2},
  ]

  plug :convert_id when action in [:show, :update]
  plug :find_lamp when action in [:show, :update]

  def index(conn, _params) do
    json conn, @lamps
  end

  def show(conn, _params) do
    json conn, conn.assigns[:lamp]
  end

  def update(conn, _params) do
  end

  defp convert_id(conn, _opts) do
    case Integer.parse(conn.params["id"]) do
      {id, ""} ->
        assign(conn, :id_as_int, id)
      _ ->
        send_resp(conn, 404, "") |> halt
    end
  end

  defp find_lamp(conn, _opts) do
    id = conn.assigns[:id_as_int]
    case Enum.find @lamps, &(Map.get(&1, :id) == id) do
      nil ->
        send_resp(conn, 404, "") |> halt
      lamp ->
        assign(conn, :lamp, lamp)
    end
  end

end

