require "../../../spec_helper"

describe Queries::MatchAll do
  describe "#to_json" do
    it "generates JSON for 'match_all' query with empty body" do
      definition = search {
        query(Queries::MatchAll) { match_all }
      }
      json = definition.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse(%({"query": {"match_all": {}}}))
      parsed.should eq expected
    end

    it "generates JSON for 'match_all' with boost" do
      definition = search {
        query(Queries::MatchAll) {
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
