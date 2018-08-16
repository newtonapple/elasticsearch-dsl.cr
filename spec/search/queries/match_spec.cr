require "../../spec_helper"

describe Queries::Match do
  describe "#from_json" do
    it "parses simple match query" do
      match = Queries::Match.from_json(%({"match": {"age": 10}}))
      match.field.should eq "age"
      match.query.should eq 10

      full = Search(Queries::Match).from_json <<-J
        {
          "query": {
            "match": {
              "width": {
                "operator": "and",
                "fuzziness": 1,
                "query": 3.14
              }
            }
          }
        }
      J
      match = full.query.as(Queries::Match)
      match.field.should eq "width"
      match.query.class.should eq Queries::Match::Query
      query = match.query.as(Queries::Match::Query)
      query.query.as(Float).should eq 3.14_f32
      query.operator.as(String).should eq "and"
      query.fuzziness.as(Int).should eq 1
    end
  end

  describe "#to_json" do
    it "generates JSON for simple 'match' query" do
      json = search(Queries::Match) {
        query { match "age", "10" }
      }.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse(%({"query": {"match": {"age":"10"}}}))
      parsed.should eq expected
    end

    it "generates JSON for complex 'match' query" do
      json = search(Queries::Match) {
        query {
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
