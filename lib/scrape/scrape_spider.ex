defmodule ScrapeSpider do
  use Crawly.Spider

  alias Crawly.Utils

  @impl Crawly.Spider
  def base_url(),
    do: "https://products.wholefoodsmarket.com/search?sort=relevance&category=meat"

  @impl Crawly.Spider
  def init(),
    do: [
      start_urls: [
        "https://products.wholefoodsmarket.com/product/organic-honeycrisp-apples-ecbd1a"
      ]
    ]

  @impl Crawly.Spider
  def get_scraped_data() do
    response =
      Crawly.fetch(
        "https://products.wholefoodsmarket.com/search?sort=relevance&category=dairy-eggs"
      )

    # response

    {:ok, document} = Floki.parse_document(response.body)

    document
    # |> Floki.raw_html()

    # |> Floki.attribute("href")

    # Floki.find(document, ".specs") |> List.first()
    # quote = Floki.find(item_block, ".text") |> Floki.text()
    # author = Floki.find(item_block, ".author") |> Floki.text()
    # tags = Floki.find(item_block, ".tags a.tag") |> Enum.map(&Floki.text/1)
    # goodreads_link =
    #   Floki.find(item_block, "a:fl-contains('(Goodreads page)')")
    #   |> Floki.attribute("href")
    #   |> Floki.text()

    # [quote, author, tags]
  end
end
