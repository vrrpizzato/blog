defmodule Blog.PostsTest do
  use Blog.DataCase
  alias Blog.{Posts, Posts.Post}

  @valid_post %{
    title: "Phoenix Framework",
    description: "Lorem Ipsum"
  }

  @update_post %{
    title: "Framework Phoenix",
    description: "Ipsum Lorem"
  }

  def post_fixture(attrs \\ %{}) do
    {:ok, post} = Posts.create_post(@valid_post)
    post
  end

  describe "Testes de funcionalidades de Contexto do Post" do
    test "create_post" do
      post = post_fixture()
      assert post.title == "Phoenix Framework"
      assert post.description == "Lorem Ipsum"
    end

    test "list_posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "update_post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Posts.update_post(post, @update_post)
      assert post.title == "Framework Phoenix"
    end

    test "delete_post" do
      assert post = Posts.delete_post(post_fixture().id)

      assert_raise Ecto.NoResultsError, fn ->
        Posts.get_post!(post.id)
      end
    end
  end
end
