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
    {:ok, post} = Blog.Posts.create_post(@valid_post)
    post
  end

  describe "Testes dependentes de setup" do
    setup [:criar_post]

    test "retornar post por identificação", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ post.title
    end

    test "entrar na página de criação de post", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :new))
      assert html_response(conn, 200) =~ "Criar Post"
    end

    test "entrar na página de edição de post", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Editar Post"
    end

    # test "verificação de post inválido", %{conn: conn} do
    #   conn = post(conn, Routes.post_path(conn, :create), post: %{})
    #   assert html_response(conn, 200) =~ "Campo obrigatório!"
    # end

    test "edição de post", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_post)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "ECHO"
    end

    # test "edição de post com campos inválidos" do
    #  {:ok, post} =  Blog.Posts.create_post(@valid_post)
    #  conn = put(conn, Routes.post_path(conn, :update, post), post: %{title: nil, description: nil})
    #  assert html_responde(conn, 200) =~ "Editar Post!"
    # end

    test "remoção de post", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  test "lista de posts", %{conn: conn} do
    Blog.Posts.create_post(@valid_post)
    conn = get(conn, Routes.post_path(conn, :index))
    assert html_response(conn, 200) =~ "Phoenix Framework"
  end

  test "criação de post", %{conn: conn} do
    conn = post(conn, Routes.post_path(conn, :create), post: @valid_post)

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == Routes.post_path(conn, :show, id)

    conn = get(conn, Routes.post_path(conn, :show, id))
    assert html_response(conn, 200) =~ "Phoenix Framework"
  end

  defp criar_post(_) do
    %{post: fixture(:post)}
  end
end
