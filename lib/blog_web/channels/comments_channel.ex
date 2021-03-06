defmodule BlogWeb.CommentsChannel do
  @moduledoc false

  use BlogWeb, :channel

  def join("comments:" <> post_id, _payload, socket) do
    post = Blog.Posts.get_post_comments!(post_id)
    {:ok, %{comments: post.comments}, assign(socket, :post_id, post.id)}
  end

  def handle_in("comment:add", content, socket) do
    response =
      socket.assigns.post_id
      |> Blog.Comments.create_comment(content)

    case response do
      {:ok, comment} ->
        broadcast!(socket, "comments: #{}:new", %{comment: comment})

        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}}
    end
  end
end
