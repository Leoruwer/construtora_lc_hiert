defmodule ConstrutoraLcHiertWeb.Router do
  use ConstrutoraLcHiertWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ConstrutoraLcHiert.Authentication.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug :put_layout, {ConstrutoraLcHiertWeb.LayoutView, :admin}
  end

  scope "/", ConstrutoraLcHiertWeb do
    pipe_through [:browser, :auth]

    get "/", HomeController, :index
    get "/quem-somos", AboutController, :index
    resources "/contato", ContactController, only: [:index, :create]

    scope "/imoveis" do
      get "/apartamentos", ApartmentController, :index
      get "/casas", HouseController, :index
      get "/lotes", LotController, :index
      get "/busca", SearchController, :index

      get "/:slug", PropertyController, :show
    end

    scope "/inscritos" do
      post "/", SubscriberController, :create
      get "/desinscrever/:id", UnsubscribeController, :index
      delete "/desinscrever/:id", UnsubscribeController, :delete
    end

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    get "/sitemap.xml", SitemapController, :index
  end

  scope "/admin", ConstrutoraLcHiertWeb, as: :admin do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/", Admin.PageController, :index

    resources "/inscritos", Admin.SubscriberController, only: [:index] do
      resources "/ativacao", Admin.Subscriber.ActivationController,
        only: [:create, :delete],
        singleton: true
    end

    resources "/usuarios", Admin.UserController
    resources "/comodidades", Admin.AmenityController, except: [:show]

    resources "/imoveis", Admin.PropertyController, except: [:show, :delete] do
      resources "/fotos", Admin.Property.ImageController,
        only: [:new, :create, :delete],
        singleton: true do
        resources "/destaque", Admin.Property.Image.FeaturedController, only: [:create]
      end
    end
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
