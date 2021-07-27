# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Blog.{Accounts, Accounts.User, Posts, Posts.Post}

user = %{
  email: "vrrpizzato@gmail.com",
  first_name: nil,
  image:
    "https://lh3.googleusercontent.com/a-/AOh14GhTlGvF1ZCE-5LeJAs3QoyVo8jst-oVttL_j6KH=s96-c",
  last_name: nil,
  provider: "google",
  token:
    "ya29.a0ARrdaM_NX0ZX1vSQ2NpNdPvO2omsuokmcQ0LRq5WRxfeoowN-fauXKBBEdqUnd3PP5qSNkRHVC2nS9KWA2V3enuX_N-xnlnoi8VYqUBQC9xAvGWbd0aLHVfYg3GXsuKlPh0VPeoG2gtuooDO1o-gN-XV31ti"
}

post = %{
  title: "Phoenix Framework",
  description:
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
}

{:ok, user} = Blog.Accounts.create_user(user)
{:ok, post} = Posts.create_post(user, post)
