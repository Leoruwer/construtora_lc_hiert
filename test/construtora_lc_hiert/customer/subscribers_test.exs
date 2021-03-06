defmodule ConstrutoraLcHiert.Customer.SubscribersTest do
  use ConstrutoraLcHiert.DataCase
  use ConstrutoraLcHiert.Fixtures, [:subscriber]

  alias ConstrutoraLcHiert.Customer.Subscribers
  alias ConstrutoraLcHiert.Customer.Subscribers.Subscriber

  describe "create_subscriber/1" do
    test "with valid data creates a subscriber" do
      assert {:ok, %Subscriber{} = subscriber} =
               Subscribers.create_subscriber(@valid_subscriber_attrs)

      assert subscriber.email == "ciro@bottini.com"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Subscribers.create_subscriber(@invalid_subscriber_attrs)
    end
  end

  describe "list_subscribers/0" do
    test "returns all subscribers" do
      subscriber = subscriber_fixture()

      assert Subscribers.list_subscribers() == [subscriber]
    end
  end

  describe "list_subscribers/1" do
    test "returns all active subscribers" do
      active_subscriber = subscriber_fixture(%{status: "active", email: "akon@tece.com"})
      _inactive_subscriber = subscriber_fixture(%{status: "inactive", email: "vitas@aaa.com"})

      assert Subscribers.list_subscribers(:active) == [active_subscriber]
    end
  end

  test "get_subscriber!/1 returns the subscriber with given id" do
    subscriber = subscriber_fixture()

    assert Subscribers.get_subscriber!(subscriber.id) == subscriber
  end

  test "get_subscriber_by!/1 returns the subscriber with given attrs" do
    subscriber = subscriber_fixture()

    assert Subscribers.get_subscriber_by!(id: subscriber.id, email: subscriber.email) ==
             subscriber
  end

  test "get_subscriber_by_email/1 returns the subscriber with given email" do
    subscriber = subscriber_fixture()

    assert Subscribers.get_subscriber_by_email(subscriber.email) == subscriber
  end

  test "activate_subscriber/1 changes the subscriber status to active" do
    subscriber = subscriber_fixture(status: "inactive")

    assert {:ok, %Subscriber{status: "active"}} = Subscribers.activate_subscriber(subscriber)
  end

  test "deactivate_subscriber/1 changes the subscriber status to inactive" do
    subscriber = subscriber_fixture(status: "active")

    assert {:ok, %Subscriber{status: "inactive"}} = Subscribers.deactivate_subscriber(subscriber)
  end

  describe "change_subscriber/1" do
    test "returns a subscriber changeset" do
      subscriber = subscriber_fixture()

      assert %Ecto.Changeset{} = Subscribers.change_subscriber(subscriber)
    end
  end
end
