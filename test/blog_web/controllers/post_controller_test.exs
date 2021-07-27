defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  @valid_post %{
    title: "Phoenix Framework",
    description: "Lorem Ipsum"
  }

  @update_post %{
    title: "ECHO",
    description: "Ipsum Lorem"
  }

  def fixture(:post) do
    user = Blog.Accounts.get_user!(1)
    {:ok, post} = Blog.Posts.create_post(user, @valid_post)
    post
  end

  describe "Testes dependentes de setup" do
    setup [:criar_post]

    test "retornar post por identificação", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ post.title
    end

    test "entrar na página de criação de post", %{conn: conn} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> get(Routes.post_path(conn, :new))

      assert html_response(conn, 200) =~ "Criar Post"
    end

    test "entrar na página de criação de post sem auth", %{conn: conn} do
      conn =
        conn
        |> get(Routes.post_path(conn, :new))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Voce precisa estar Logado!"
    end

    test "entrar na página de edição de post", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> get(Routes.post_path(conn, :edit, post))

      assert html_response(conn, 200) =~ "Editar Post"
    end

    test "edição de post", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> put(Routes.post_path(conn, :update, post), post: @update_post)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "ECHO"
    end

    test "remoção de post", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: 1)
        |> delete(Routes.post_path(conn, :delete, post))

      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  test "lista de posts", %{conn: conn} do
    user = Blog.Accounts.get_user!(1)
    Blog.Posts.create_post(user, @valid_post)
    conn = get(conn, Routes.post_path(conn, :index))
    assert html_response(conn, 200) =~ "Phoenix Framework"
  end

  test "criação de post", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(user_id: 1)
      |> post(Routes.post_path(conn, :create), post: @valid_post)

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == Routes.post_path(conn, :show, id)

    conn = get(conn, Routes.post_path(conn, :show, id))
    assert html_response(conn, 200) =~ "Phoenix Framework"
  end

  defp criar_post(_) do
    %{post: fixture(:post)}
  end
end
