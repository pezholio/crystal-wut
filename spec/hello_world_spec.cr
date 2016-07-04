require "./spec_helper"

describe HelloWorld do
  # Be sure to start your app in test mode
  start

  Spec.before_each do
    DB.exec("TRUNCATE TABLE people")
  end

  # You can use get,post,put,patch,delete to call the corresponding route.
  it "renders /" do
    get "/"
    response.body.should eq "302"
  end

  it "shows some data" do
    put "/people", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      name: "Foo",
      age: 123
    }.to_json

    put "/people", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      name: "Bar",
      age: 345
    }.to_json

    get "/people"
    json = JSON.parse(response.body)
    json["people"].size.should eq(2)
  end

  it "shows data for a user" do
    put "/people", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      name: "Foo",
      age: 123
    }.to_json

    result = DB.exec("SELECT * FROM \"people\"").rows

    get "/people/#{result[0][0]}"
    json = JSON.parse(response.body)
    json["name"].should eq("Foo")
    json["age"].should eq(123)
  end

  it "adds some data" do
    put "/people", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      name: "Foo",
      age: 123
    }.to_json

    DB.exec("SELECT * FROM \"people\"").rows.size.should eq(1)
  end

  # Be sure to stop your app after the specs
  stop
end
