defmodule Home.Router do
  use Home.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Home do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1", Home.API.V1 do
    pipe_through :api

    resources "/lamps", LampController, only: [:index, :show, :update]

    resources "/rooms", RoomController,
      [only: [:index, :show], param: "room_id"]

    scope "/rooms/:room_id" do
      post "/command/:command", RoomController, :command
    end
  end
end
