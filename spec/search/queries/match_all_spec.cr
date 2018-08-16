require "../../spec_helper"

describe Queries::MatchAll do
  describe "#from_json" do
    it "parses 'match_all' JSON with empty body" do
      match_all_query = Queries::MatchAll.from_json(%({"match_all": {}}))
      match_all_query.boost.should be_nil

      full_query = Search(Queries::MatchAll).from_json(%({"query":{"match_all": {}}}))
      full_query.query.as(Queries::MatchAll).boost.should be_nil
    end

    it "parses 'match_all' JSON with boost" do
      match_all_query = Queries::MatchAll.from_json(%({"match_all": {"boost": 99}}))
      match_all_query.boost.should eq 99

      full_query = Search(Queries::MatchAll).from_json(%({"query":{"match_all": {"boost": 101}}}))
      full_query.query.as(Queries::MatchAll).boost.should eq 101
    end
  end

  describe "#to_json" do
    it "generates JSON for 'match_all' query with empty body" do
      definition = search(Queries::MatchAll) {
        query { match_all }
      }
      json = definition.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse(%({"query": {"match_all": {}}}))
      parsed.should eq expected
    end

    it "generates JSON for 'match_all' with boost" do
      definition = search(Queries::MatchAll) {
        query {
          match_all { boost 100.01 }
        }
      }
      json = definition.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse <<-J
      {
        "query": {
          "match_all": { "boost": 100.01 }
        }
      }
      J
      parsed.should eq expected
    end
  end
end
