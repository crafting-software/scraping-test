defmodule Scraping do
  use Crawly.Spider

  alias Scrape.Products
  alias Scrape.Ingredients
  alias Scrape.ProductIngredients

  @limit 20
  @product_url_base "https://products.wholefoodsmarket.com/product/"

  def list_product_categories() do
    [
      %{cat: "produce", subcat: ["fresh-fruit", "fresh-herbs", "fresh-vegetables"]},
      %{
        cat: "dairy-eggs",
        subcat: [
          "butter-margarine",
          "cheese",
          "dairy-alternatives",
          "eggs",
          "milk-cream",
          "yogurt"
        ]
      },
      %{
        cat: "meat",
        subcat: [
          "beef",
          "chicken",
          "pork",
          "turkey",
          "goat-lamb-veal",
          "bacon",
          "hotdogs-sausage",
          "game-meats",
          "meat-alternatives"
        ]
      },
      %{cat: "prepared-foods", subcat: ["prepared-meals", "prepared-soups-salad"]},
      %{
        cat: "pantry-essentials",
        subcat: [
          "baking",
          "canned-goods",
          "cereal",
          "condiments-dressings",
          "hot-cereal-pancake-mixes",
          "jam-jellies-nut-butters",
          "pasta-noodles",
          "rice-grains",
          "sauces",
          "soups-broths",
          "spices-seasonings"
        ]
      },
      %{
        cat: "breads-rolls-bakery",
        subcat: [
          "breads",
          "breakfast-bakery",
          "desserts",
          "rolls-buns",
          "tortillas-flat-breads"
        ]
      },
      %{cat: "body-care", subcat: ["aromatherapy", "baby-child", "bath-body", "personal-care"]},
      %{
        cat: "supplements",
        subcat: [
          "childrens-health",
          "functional-foods",
          "functional-supplements",
          "herbs-homeopathy",
          "specialty-supplements",
          "sports-nutrition-weight-management",
          "vitamins-minerals",
          "wellness-seasonal"
        ]
      },
      %{
        cat: "frozen-foods",
        subcat: [
          "frozen-breakfast",
          "frozen-fruits-vegetables",
          "frozen-pizza",
          "ice-cream-frozen-desserts"
        ]
      },
      %{
        cat: "snacks-chips-salsas-dips",
        subcat: [
          "candy-chocolate",
          "chips",
          "cookies",
          "crackers",
          "jerky",
          "nutrition-granola-bars",
          "nuts-seeds-dried-fruit",
          "popcorn-puffs-rice-cakes",
          "salsas-dips-spreads"
        ]
      },
      %{cat: "seafood", subcat: ["fish", "shellfish"]},
      %{
        cat: "beverages",
        subcat: [
          "coffee",
          "juice",
          "kombucha-tea",
          "soft-drinks",
          "sports-energy-nutritional-drinks",
          "tea",
          "water-seltzer-sparkling-water"
        ]
      },
      %{cat: "wine-beer-spirits", subcat: ["beer", "spirits", "wine"]},
      %{cat: "beauty", subcat: ["cosmetics", "facial-care", "hair-care", "perfume"]},
      %{cat: "beauty", subcat: ["cosmetics", "facial-care", "hair-care", "perfume"]}
    ]
    |> Enum.map(fn cc -> Enum.map(cc.subcat, fn x -> %{cat: cc.cat, subcat: x} end) end)
    |> List.flatten()
  end

  def get_scraped_data() do
    categories = list_product_categories()

    product_ids =
      Enum.reduce(categories, [], fn category, acc ->
        products = fetch_products(category.cat, category.subcat)

        products ++ acc
      end)

    link = product_ids |> Enum.at(0)

    Enum.map(product_ids, fn link ->
      url = "https://products.wholefoodsmarket.com/api/Product/" <> link

      product_data =
        Crawly.fetch(url).body
        |> Poison.decode!()

      create_product(product_data)
    end)
  end

  def create_product(product) do
    {:ok, new_product} =
      %{
        name: product["name"],
        brand_name: product["brand"]["name"]
      }
      |> Products.create_product()

    ingredients = product["ingredientList"]

    ingredients
    |> Enum.map(fn ingredient ->
      existing_ingredient = Ingredients.get_ingredient_by_name(ingredient)

      if existing_ingredient do
        ProductIngredients.add_product_ingredient(new_product.id, existing_ingredient.id)
      else
        {:ok, new_ingredient} = Ingredients.create_ingredient(%{name: ingredient})
        ProductIngredients.add_product_ingredient(new_product.id, new_ingredient.id)
      end
    end)
  end

  def generate_products_url_by_category(category, subcategory, skip) do
    "https://products.wholefoodsmarket.com/api/search?sort=relevance&store=&skip=#{skip}&filters=%5B%7B%22ns%22%3A%22category%22%2C%22key%22%3A%22#{
      category
    }%22%2C%22value%22%3A%22#{category}%22%7D%2C%7B%22ns%22%3A%22subcategory%22%2C%22key%22%3A%22#{
      subcategory
    }%22%2C%22value%22%3A%22#{category <> "." <> subcategory}%22%7D%5D"
  end

  def fetch_products(category, subcategory) do
    response =
      Crawly.fetch(generate_products_url_by_category(category, subcategory, 0)).body
      |> Poison.decode!()

    skip = Map.get(response, "skip")
    total = Map.get(response, "total")

    get_products(category, subcategory, skip, total, [])
  end

  def get_products(_, _, skip, total, acc) when skip + @limit >= total do
    acc
  end

  def get_products(category, subcategory, skip, total, acc) do
    request =
      Crawly.fetch(generate_products_url_by_category(category, subcategory, skip)).body
      |> Poison.decode!()

    items = request |> Map.get("list")
    products = items |> Enum.map(fn x -> Map.get(x, "slug") end)

    get_products(category, subcategory, skip + @limit, total, products ++ acc)
  end
end
