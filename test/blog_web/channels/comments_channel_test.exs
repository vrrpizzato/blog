defmodule BlogWeb.CommentsChannelTest do
  use BlogWeb.ChannelCase

  alias BlogWeb.UserSocket

  @valid_post %{
    title: "Phoenix Framework",
    description: "Lorem Ipsum"
  }

  describe "TESTE WEBSOCKETS" do
    setup do
      user = Blog.Accounts.get_user!(1)
      token = Phoenix.Token.sign(BlogWeb.Endpoint, "blog_user", user.id)
      {:ok, post} = Blog.Posts.create_post(user, @valid_post)
      {:ok, socket} = connect(UserSocket, %{"token" => token})
      {:ok, socket: socket, post: post}
    end

    test "deve conectar ao post via socket", %{socket: socket, post: post} do
      {:ok, comentarios, socket} = subscribe_and_join(socket, "comments:#{post.id}", %{})

      assert post.id == socket.assigns.post_id
      assert [] == comentarios.comments
    end

    test "deve criar um comentário", %{socket: socket, post: post} do
      {:ok, _comentarios, socket} = subscribe_and_join(socket, "comments:#{post.id}", %{})

      event_ref = push(socket, "comment:add", %{"content" => "echo event"})
      assert_reply event_ref, :ok, %{}

      comentario = %{comment: %{content: "echo event"}}
      broadcast_event = "comments:#{post.id}:new"
      assert_broadcast broadcast_event, comentario
      refute is_nil(comentario)
    end
  end
end
