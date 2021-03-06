defmodule ConstrutoraLcHiertWeb.Admin.UserControllerTest do
  use ConstrutoraLcHiertWeb.ConnCase
  use ConstrutoraLcHiert.Fixtures, [:user]

  alias ConstrutoraLcHiert.Repo
  alias ConstrutoraLcHiert.Account.Users.User

  describe "GET /admin/usuarios" do
    @tag :sign_in_user
    test "accesses the users page", %{conn: conn} do
      conn = get(conn, "/admin/usuarios")

      assert html_response(conn, 200) =~ "Usuários"
    end
  end

  describe "GET /admin/usuarios/:id" do
    @tag :sign_in_user
    test "accesses the user page", %{conn: conn, user: user} do
      conn = get(conn, "/admin/usuarios/#{user.id}")

      assert html_response(conn, 200) =~ "Olá, #{user.username}"
    end
  end

  describe "GET /admin/usuarios/new" do
    @tag :sign_in_user
    test "accesses the users new page", %{conn: conn} do
      conn = get(conn, "/admin/usuarios/new")

      assert html_response(conn, 200) =~ "Cadastrar Usuário"
    end
  end

  describe "POST /admin/usuarios" do
    @tag :sign_in_user
    test "creates a new user", %{conn: conn} do
      conn = post(conn, "/admin/usuarios", %{user: @valid_user_attrs})

      refute Repo.get_by(User, username: "biridin") == nil

      assert redirected_to(conn) == "/admin/usuarios/new"
    end

    @tag :sign_in_user
    test "returns the error page when the params are invalid", %{conn: conn} do
      conn = post(conn, "/admin/usuarios", %{user: @invalid_user_attrs})

      assert html_response(conn, 200) =~ "Cadastrar Usuário"

      assert html_response(conn, 200) =~
               "Oops! Ocorreu um problema. Por favor, resolva os erros abaixo."

      assert html_response(conn, 200) =~ "não pode ficar em branco"
    end
  end

  describe "GET /admin/usuarios/:id/edit" do
    @tag :sign_in_user
    test "accesses the users edit page", %{conn: conn, user: user} do
      conn = get(conn, "/admin/usuarios/#{user.id}/edit")

      assert html_response(conn, 200) =~ "Alterar Usuário"
    end
  end

  describe "PUT /admin/usuarios/:id" do
    @tag :sign_in_user
    test "updates the given user", %{conn: conn, user: user} do
      conn = put(conn, "/admin/usuarios/#{user.id}", %{user: @update_user_attrs})

      assert Repo.get_by(User, username: "biridin") == nil
      refute Repo.get_by(User, username: "biridin_updated") == nil

      assert redirected_to(conn) == "/admin/usuarios/#{user.id}/edit"
    end

    @tag :sign_in_user
    test "returns the error page when the params are invalid", %{conn: conn, user: user} do
      conn = put(conn, "/admin/usuarios/#{user.id}", %{user: @invalid_user_attrs})

      assert html_response(conn, 200) =~ "Alterar Usuário"

      assert html_response(conn, 200) =~
               "Oops! Ocorreu um problema. Por favor, resolva os erros abaixo."

      assert html_response(conn, 200) =~ "não pode ficar em branco"
    end
  end

  describe "DELETE /admin/usuarios/:id" do
    @tag :sign_in_user
    test "deletes the user", %{conn: conn, user: user} do
      conn = delete(conn, "/admin/usuarios/#{user.id}")

      refute Repo.get_by(User, username: user.username).deleted_at == nil

      assert get_flash(conn, :info) =~ "Excluído com sucesso"
      assert redirected_to(conn) == "/admin/usuarios"
    end
  end
end
