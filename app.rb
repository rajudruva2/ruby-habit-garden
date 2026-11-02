require "sinatra"
require "json"

set :bind, "0.0.0.0"
set :port, ENV.fetch("PORT", "4569").to_i
set :show_exceptions, false

SEED_DATA = [{"id":1,"name":"Read for 10 minutes","completed":false}]
ITEMS = Marshal.load(Marshal.dump(SEED_DATA))

before do
  content_type :json
end

helpers do
  def json_body
    request.body.rewind
    raw = request.body.read
    return {} if raw.nil? || raw.empty?
    JSON.parse(raw)
  rescue JSON::ParserError
    halt 400, { error: "Request body must be valid JSON" }.to_json
  end

  def next_id(items)
    (items.map { |item| item["id"].to_i }.max || 0) + 1
  end
end

get "/" do
  { app: "Habit Garden API", message: "API is running", endpoints: ["/health", "/habits"] }.to_json
end

get "/health" do
  { status: "ok", app: "ruby-habit-garden" }.to_json
end

get "/habits" do
  results = ITEMS
  if params["q"]
    q = params["q"].downcase
    results = results.select { |item| item.to_json.downcase.include?(q) }
  end
  results.to_json
end

get "/habits/:id" do
  item = ITEMS.find { |entry| entry["id"] == params["id"].to_i }
  halt 404, { error: "Record not found" }.to_json unless item
  item.to_json
end

post "/habits" do
  data = json_body
  halt 422, { error: "name is required" }.to_json unless data["name"].is_a?(String) && !data["name"].strip.empty?
  data["id"] = next_id(ITEMS)
  data["completed"] = false unless data.key?("completed")
  ITEMS << data
  status 201
  data.to_json
end

delete "/habits/:id" do
  index = ITEMS.index { |entry| entry["id"] == params["id"].to_i }
  halt 404, { error: "Record not found" }.to_json unless index
  ITEMS.delete_at(index)
  status 204
  ""
end
