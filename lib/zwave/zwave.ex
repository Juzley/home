defmodule ZWave do
  @api "ZAutomation/api/v1/"

  def start, do: HTTPoison.start

  def activate_scene scene do
    HTTPoison.get(api_url() <> "devices/" <> scene <> "/command/on")
  end

  def device_on device do
    HTTPoison.get(api_url() <> "devices/" <> device <> "/command/on")
  end

  def device_off device do
    HTTPoison.get(api_url() <> "devices/" <> device <> "/command/off")
  end

  defp base_url do
    [user: user, password: pass, ip: ip, port: port] =
      Application.get_env(:home, ZWave)

    Enum.join ["http://", user, ":", pass, "@", ip, ":", port, "/"]
  end

  defp api_url, do: base_url() <> @api
end
