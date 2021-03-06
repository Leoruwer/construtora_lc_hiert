defmodule ConstrutoraLcHiertWeb.Admin.Subscriber.ActivationControllerTest do
  use ConstrutoraLcHiertWeb.ConnCase
  use ConstrutoraLcHiert.Fixtures, [:subscriber]

  describe "POST /admin/inscritos/:id/ativacao" do
    setup [:create_subscriber]

    @tag :sign_in_user
    test "activates the subscriber", %{conn: conn, subscriber: subscriber} do
      conn = post(conn, "/admin/inscritos/#{subscriber.id}/ativacao")

      assert get_flash(conn, :info) =~ "Ativado com sucesso"
      assert redirected_to(conn) =~ "/admin/inscritos"
    end
  end

  describe "DELETE /admin/inscritos/:id/ativacao" do
    setup [:create_subscriber]

    @tag :sign_in_user
    test "deactivates the subscriber", %{conn: conn, subscriber: subscriber} do
      conn = delete(conn, "/admin/inscritos/#{subscriber.id}/ativacao")

      assert get_flash(conn, :info) =~ "Desativado com sucesso"
      assert redirected_to(conn) =~ "/admin/inscritos"
    end
  end

  defp create_subscriber(_) do
    subscriber = subscriber_fixture()

    {:ok, subscriber: subscriber}
  end
end
