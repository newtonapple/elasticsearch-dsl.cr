require "../../../spec_helper"

describe Queries::Match do
  describe "#to_json" do
    it "generates JSON for simple match query" do
      json = search {
        query(Queries::Match) { match "age", "10" }
      }.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse(%({"query": {"match": {"age":"10"}}}))
      parsed.should eq expected
    end

    it "generates JSON for complex match query" do
      json = search {
        query(Queries::Match) {
          match "age" {
            query "10"
            operator "and"
            fuzziness 1_u8
          }
        }
      }.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse <<-J
      {
        "query": {
            "match": {
            "age": {
              "operator": "and",
              "fuzziness": 1,
              "query": "10"
            }
          }
        }
      }
      J
      parsed.should eq expected
    end
  end
end
