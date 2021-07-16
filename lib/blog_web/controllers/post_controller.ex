defmodule BlogWeb.PostController do
  use BlogWeb, :controller
  alias Blog.{Posts, Posts.Post}

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def create(conn, %{"post" => post}) do
    post = Posts.create_post(post)

    case post do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post criado com sucesso!")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.update_post(id, post_params)

    case post do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post atualizado com sucesso!")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Posts.delete_post(id)

    conn
    |> put_flash(:info, "Post deletado!")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
