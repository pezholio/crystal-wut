require "./hello_world/*"
require "kemal"

module HelloWorld
  get "/" do |env|
    env.redirect "/people"
  end

  get "/people" do |env|
    env.response.content_type = "application/json"
    result = DB.exec("SELECT * FROM \"people\"")
    people = result.to_hash.map do |person|
      "http://localhost:3000/people/#{person["id"] as Int}" as String
    end
    {
      people: people
    }.to_json
  end

  put "/people" do |env|
    env.response.content_type = "application/json"

    DB.exec("INSERT INTO people (name, age) VALUES ('#{env.params.json["name"]}', '#{env.params.json["age"]}')").rows
    env.response.status_code = 201
    nil
  end

  get "/people/:id" do |env|
    env.response.content_type = "application/json"

    result = DB.exec("SELECT * FROM people WHERE id = #{env.params.url["id"]}").rows
    person = result[0]
    {
      name: person[1] as String,
      age: person[2] as Int
    }.to_json
  end
end

Kemal.run unless ENV.has_key?("environment") && ENV["environment"] == "test"
