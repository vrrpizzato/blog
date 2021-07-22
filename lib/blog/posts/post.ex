defmodule Blog.Posts.Post do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :description, :string

    has_many :comments, Blog.Comments.Comment
    timestamps()
  end

  def changeset(post, attrs \\ %{}) do
    post
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description], message: "Campo obrigatório!")
  end
end
