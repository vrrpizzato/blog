defmodule Blog.PostsTest do
  use Blog.DataCase
  alias Blog.{Posts, Posts.Post}


  describe "Testes de criação de post" do

    @valid_post %{
      title: "Phoenix Framework",
      description: "Lorem Ipsum"
    }

    test "create_post" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_post)
      assert post.title == "Phoenix Framework"
      assert post.description == "Lorem Ipsum"
    end

  end

end
