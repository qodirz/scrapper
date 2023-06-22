json.extract! client, :id, :username, :password, :first_name, :last_name, :point, :platform, :created_at, :updated_at
json.url client_url(client, format: :json)
