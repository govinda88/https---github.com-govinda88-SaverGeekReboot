defmodule SaverAdmin.Periodically do
  use GenServer
  use Hound.Helpers

  @config domain: Application.get_env(:saver_admin, :mailgun_domain),
          key: Application.get_env(:saver_admin, :mailgun_key)
  use Mailgun.Client, @config

  alias SaverAdmin.Repo
  alias SaverAdmin.Product

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 5 * 60 * 1000) # In 5 minutes
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    for product <- Repo.all(Product) do
      url = product.url  
      dbprice = product.price
      dbstock = product.stock
      name = product.name
      ebayid = product.ebayid

      update =
        case HTTPoison.get(url) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            pricecheck = Floki.find(body, ".Price--medium")
                         |> Floki.text
                         |> f1
                         |> Float.parse
                         |> Tuple.append(dbprice)
                         |> f2
        
            stockcheck = Floki.find(body, ".price-oos")
                         |> Floki.text
                         |> f3
                         |> Tuple.append(dbstock)
                         |> f4

            info = {stockcheck, pricecheck}             
          {:ok, %HTTPoison.Response{status_code: 404}} ->
            {:error, "not found"}
          {:error, %HTTPoison.Error{reason: reason}} ->
            {:error, reason}
        end
      
      case update do
        {{sstatus, stock}, {pstatus, price}} when sstatus == :update and pstatus == :new ->
          IO.inspect stock
          IO.inspect price
          product = Ecto.Changeset.change product, price: price, stock: stock
          Repo.update product
          cond do
            stock == true ->
              SaverAdmin.Ebay.revise_inv(3, ebayid)
            stock == false ->
              SaverAdmin.Ebay.revise_inv(0, ebayid)
          end
          send_email to: "admin@savergeek.com",
                     from: "info@savergeek.com",
                     subject: "Price & Stock Update",
                     html: "The new price for " <> name <> " is " <> Float.to_string(price, [decimals: 2, compact: true]) <> ". The store is currently " <> if stock, do: "in stock", else: "out of stock.   " <> url
        {{sstatus, stock}, {pstatus, price}} when sstatus == :update ->
          IO.inspect stock
          product = Ecto.Changeset.change product, stock: stock
          Repo.update product 
          cond do
            stock == true ->
              SaverAdmin.Ebay.revise_inv(3, ebayid)
            stock == false->
              SaverAdmin.Ebay.revise_inv(0, ebayid)
          end
          send_email to: "admin@savergeek.com",
                     from: "info@savergeek.com",
                     subject: "Stock Update",
                     html: "The stock has changed for " <> name <> ". The store is currently " <> if stock, do: "in stock", else: "out of stock.  " <> url 
        {{sstatus, stock}, {pstatus, price}} when pstatus == :new ->
          IO.inspect price
          product = Ecto.Changeset.change product, price: price
          Repo.update product 
          send_email to: "admin@savergeek.com",
                     from: "info@savergeek.com",
                     subject: "Price Update",
                     html: "The new price for " <> name <> "  is $" <> Float.to_string(price, [decimals: 2, compact: true]) <> "   "  <>url
        {{sstatus, stock}, {pstatus, price}} when pstatus == :same and sstatus == :same ->
          IO.inspect price
          IO.inspect stock
          
          response = cond do
            stock == true ->
              SaverAdmin.Ebay.revise_inv(3, ebayid)
            stock == false->
              SaverAdmin.Ebay.revise_inv(0, ebayid)
          end
        _ ->
          IO.inspect update
          
          
      end
    end

    # Start the timer again
    Process.send_after(self(), :work, 5 * 60 * 1000) # In 5 minutes

    {:noreply, state}
  end

  def f1(price) do
    String.replace(price, "$", "")
    |>String.strip
  end

  def f2(price) do
    case price do
      {nprice, x, dbprice} when nprice == dbprice ->
        {:same, elem(price, 0)}
      _ -> 
        {:new, elem(price, 0)}
    end
  end  

  def f3(stock) do
    case stock do
      nstock when nstock == "Out of stock" ->
        {stock, false}
      _ ->
        {stock, true}
    end
  end

  def f4(stock) do
    case stock do
      {x,y,z} when y == false and z == true -> 
        {:update, false}
      {x,y,z} when y == true and z == false ->
        {:update, true}
      {x,y,z} when y == true and z == true ->
        {:same, true}
      {x,y,z} when y == false and z == false ->
        {:same, false}
      _ ->
        {:same, false}
    end
  end

end
