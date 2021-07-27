defmodule BlogWeb.AuthControllerTest do
  use BlogWeb.ConnCase

  @ueberauth %Ueberauth.Auth{
    credentials: %{token: "token_echo"},
    info: %{
      email: "email_echo",
      first_name: "first_name_echo",
      last_name: "last_name_echo",
      image: "image_echo"
    },
    provider: "google"
  }

  @ueberauth_invalido %Ueberauth.Auth{
    credentials: %{token: nil},
    info: %{
      email: "email_echo",
      first_name: nil,
      last_name: nil,
      image: nil
    },
    provider: nil
  }

  test "callback sucess", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth)
      |> get(Routes.auth_path(conn, :callback, "google"))

    assert redirected_to(conn) == Routes.page_path(conn, :index)
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200) =~ "Seja bem-vindo!"
  end

  test "callback failure", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_invalido)
      |> get(Routes.auth_path(conn, :callback, "google"))

    assert redirected_to(conn) == Routes.page_path(conn, :index)
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200) =~ "Algo deu errado!"
  end

  test "logout success", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(user_id: 1)
      |> get(Routes.auth_path(conn, :logout))

    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end
end
