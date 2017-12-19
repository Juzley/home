defmodule Home.API.V1.SceneController do
  use Home.Web, :controller

  def activate(conn, params) do
    ZWave.activate_scene conn.params["scene_id"]
    send_resp(conn, 200, "")
  end
end
