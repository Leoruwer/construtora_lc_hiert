defmodule ConstrutoraLcHiertWeb.SessionControllerTest do
  use ConstrutoraLcHiertWeb.ConnCase
  use ConstrutoraLcHiert.Fixtures, [:user]

  alias ConstrutoraLcHiert.Authentication.Guardian

  describe "GET /login" do
    test "accesses the login page", %{conn: conn} do
      conn = get(conn, "/login")

      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "POST /login" do
    setup [:create_user]

    test "redirects to admin page if user is authenticated", %{conn: conn} do
      conn = post(conn, "/login", user: @valid_user_attrs)

      assert redirected_to(conn) == "/admin"
    end

    test "displays error message if user is not found", %{conn: conn} do
      conn = post(conn, "/login", user: %{username: "invalid_user", password: "some_pass"})

      assert html_response(conn, 200) =~ "não encontrado"
    end

    test "displays error message if password is incorrect", %{conn: conn} do
      conn = post(conn, "/login", user: %{username: "biridin", password: "wrong_pass"})

      assert html_response(conn, 200) =~ "senha está incorreta"
    end
  end

  describe "DELETE /logout" do
    setup [:create_user]

    test "signs out the user", %{conn: conn, user: user} do
      conn = Guardian.Plug.sign_in(conn, user)

      conn = delete(conn, "/logout")
      assert redirected_to(conn) == "/"

      conn = get(conn, "/admin")
      assert redirected_to(conn) == "/login"
    end
  end

  defp create_user(_) do
    user = user_fixture()

    {:ok, user: user}
  end
end
