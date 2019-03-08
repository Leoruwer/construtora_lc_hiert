defmodule ConstrutoraLcHiertWeb.SessionController do
  use ConstrutoraLcHiertWeb, :controller

  alias ConstrutoraLcHiert.Accounts
  alias ConstrutoraLcHiert.Accounts.User
  alias ConstrutoraLcHiert.Authentication.Guardian

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: Routes.admin_page_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :create))
    end
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    username
    |> Accounts.verify_user_credentials(password)
    |> login_reply(conn)
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: Routes.admin_page_path(conn, :index))
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
