json.array!(@merchants) do |merchant|
  json.extract! merchant, :id, :name, :logo
  json.url merchant_url(merchant, format: :json)
end
