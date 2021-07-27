defmodule BlogWeb.Plug.RequireAuth do
  @moduledoc false

  use BlogWeb, :controller
  import Plug.Conn

  def init(_), do: nil

  def call(conn, _) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "Voce precisa estar Logado!")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
