json.array!(@products) do |product|
  json.extract! product, :id, :name, :image, :price, :special_instructions
  json.url product_url(product, format: :json)
end
