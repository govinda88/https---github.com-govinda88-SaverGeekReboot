defmodule SaverAdmin.PageController do
  use SaverAdmin.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
