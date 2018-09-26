defmodule SaverAdmin.Ebay do

  def revise_inv(quantity, ebayid) do
    headers =      [{"X-EBAY-API-COMPATIBILITY-LEVEL", "963"}, 
                    {"X-EBAY-API-DEV-NAME", "6c6528bc-a9a7-4eda-a6eb-d5b47be6520a"}, 
                    {"X-EBAY-API-APP-NAME", "SaverGee-StockUpd-PRD-505763884-1d285fd8"}, 
                    {"X-EBAY-API-CERT-NAME", "PRD-057638847a53-ab6e-49ee-9155-2257"},
                    {"X-EBAY-API-SITEID", "0"}, 
                    {"X-EBAY-API-CALL-NAME", "ReviseInventoryStatus"}]

    xml_request =  """
                   <?xml version="1.0" encoding="utf-8"?>
                   <ReviseInventoryStatusRequest xmlns="urn:ebay:apis:eBLBaseComponents">
                   <RequesterCredentials>
                     <eBayAuthToken>AgAAAA**AQAAAA**aAAAAA**f0UZVw**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6AEl4qpDpOBoASdj6x9nY+seQ**uD4DAA**AAMAAA**avpI0VPle4ExLQoHXOLn2PCQvIGXexLPxpA09ZuT3Lb3KAvOcpOIlEebH61Ft2tbyVuLgXukd0OCvZ9fVGMcB4MzJiHp33cDpvlUsHw4zYva81BGsslRcrT15dEi4panUnErjCW6w4uEynBLLtnQ+LZSR4uruS0/P/naMbX1Id6bChkl2Tt/KE4BBgzVM0eyR7pHaxGKaRoqxhzHQEkvfg42UMzD5HhEOkBhvGVOR3TxE1zhXJP1nc4+hDvXalSVeUQDw61/IfTozrGbQ0NEyU0OUT+b0gYjTnxufvZ3Z22Abfxfgi8Lot4P3fVBN9YXZIvFPRyY7fwnECVoAdp/vPE53nYpvsKBQOII0zz77IMHiM2NtfDyJI/Wphkrn/zEVMvKMVBVftibIzEq+TrIbXj3tz0tDMn9fjEneecqOyXmUeBOuz/r5IjXR0QhRwYjChtAhl/AR8ffi+syLIxNtDV4x0qQj+TYD/u+BmhdmlX38lI0yJk7armZQV380HcshS0zLFF2t0/2puOfM2AN6xstLj0oo2eH2pkUJbPupniRpjEJL/QSCeBssB6bMIvWSF6XeQmmmqciUyzXIQkXkblTB57nbXbGab2/cFjVz8c0td4ACtS/ct6oUPfR9f1h8GFdSa1XOC/Jr4xLMiNOIceWyWPRuyeNiNmQXXutT8SQwtF0eAgUQkoTnOpEvZFYUi96oZgQEJgjElqk0ci1LAwvTz/ykUXuOc4l11Gm4tpZCvCHOoSXySxb6X1bN2HC</eBayAuthToken>
                   </RequesterCredentials>
                   <InventoryStatus>
                     <ItemID>#{ebayid}</ItemID>
                     <Quantity>#{quantity}</Quantity>
                   </InventoryStatus>
                   </ReviseInventoryStatusRequest>
                    """

    HTTPoison.post("https://api.ebay.com/ws/api.dll",xml_request, headers)
  end  

  import SweetXml

  def get_item(ebayid) do
    headers =      [{"X-EBAY-API-COMPATIBILITY-LEVEL", "963"}, 
                    {"X-EBAY-API-DEV-NAME", "6c6528bc-a9a7-4eda-a6eb-d5b47be6520a"}, 
                    {"X-EBAY-API-APP-NAME", "SaverGee-StockUpd-PRD-505763884-1d285fd8"}, 
                    {"X-EBAY-API-CERT-NAME", "PRD-057638847a53-ab6e-49ee-9155-2257"},
                    {"X-EBAY-API-SITEID", "0"}, 
                    {"X-EBAY-API-CALL-NAME", "GetItem"}]
    xml_request =  """
                   <?xml version="1.0" encoding="utf-8"?>
                   <GetItemRequest xmlns="urn:ebay:apis:eBLBaseComponents">
                   <RequesterCredentials>
                     <eBayAuthToken>AgAAAA**AQAAAA**aAAAAA**f0UZVw**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6AEl4qpDpOBoASdj6x9nY+seQ**uD4DAA**AAMAAA**avpI0VPle4ExLQoHXOLn2PCQvIGXexLPxpA09ZuT3Lb3KAvOcpOIlEebH61Ft2tbyVuLgXukd0OCvZ9fVGMcB4MzJiHp33cDpvlUsHw4zYva81BGsslRcrT15dEi4panUnErjCW6w4uEynBLLtnQ+LZSR4uruS0/P/naMbX1Id6bChkl2Tt/KE4BBgzVM0eyR7pHaxGKaRoqxhzHQEkvfg42UMzD5HhEOkBhvGVOR3TxE1zhXJP1nc4+hDvXalSVeUQDw61/IfTozrGbQ0NEyU0OUT+b0gYjTnxufvZ3Z22Abfxfgi8Lot4P3fVBN9YXZIvFPRyY7fwnECVoAdp/vPE53nYpvsKBQOII0zz77IMHiM2NtfDyJI/Wphkrn/zEVMvKMVBVftibIzEq+TrIbXj3tz0tDMn9fjEneecqOyXmUeBOuz/r5IjXR0QhRwYjChtAhl/AR8ffi+syLIxNtDV4x0qQj+TYD/u+BmhdmlX38lI0yJk7armZQV380HcshS0zLFF2t0/2puOfM2AN6xstLj0oo2eH2pkUJbPupniRpjEJL/QSCeBssB6bMIvWSF6XeQmmmqciUyzXIQkXkblTB57nbXbGab2/cFjVz8c0td4ACtS/ct6oUPfR9f1h8GFdSa1XOC/Jr4xLMiNOIceWyWPRuyeNiNmQXXutT8SQwtF0eAgUQkoTnOpEvZFYUi96oZgQEJgjElqk0ci1LAwvTz/ykUXuOc4l11Gm4tpZCvCHOoSXySxb6X1bN2HC</eBayAuthToken>
                   </RequesterCredentials>
                     <ItemID>#{ebayid}</ItemID>
                   </GetItemRequest>

                   """

    result = HTTPoison.post("https://api.ebay.com/ws/api.dll",xml_request, headers)
    case result do
      {:ok, %HTTPoison.Response{body: body}} ->
        test = body |> xpath(~x"//Ack/text()"s)
        if test === "Success" do 
          result = body |> xmap(
            itURL: ~x"//Item/ListingDetails/ViewItemURL/text()",
            price: ~x"//Item/SellingStatus/CurrentPrice/text()"f,
            qsold: ~x"//Item/SellingStatus/QuantitySold/text()"i,
            quant: ~x"//Item/Quantity/text()"i,
            count: ~x"//Item/HitCount/text()"i)
        else 
          IO.puts "ItemID Ack returned Fail"
          %{:itURL => "#", :price => 0.0, :qsold => 0, :quant => 0, :count => 0}
        end
      _ ->
        IO.puts "errorz"
    end
  end

end
