require "../../../spec_helper"

describe Queries::MatchPhrase do
  describe "#to_json" do
    it "generates JSON for match_phrase with a string query" do
      definition = search {
        query(Queries::MatchPhrase) {
          match_phrase "body", "that is the question"
        }
      }
      json = definition.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse(%({"query": {"match_phrase": {"body": "that is the question"}}}))
      parsed.should eq expected
    end

    it "generates JSON for match_phrase with complex query" do
      definition = search {
        query(Queries::MatchPhrase) {
          match_phrase "description" {
            query "to be or not to be"
            analyzer "my_analyzer"
            slop 1_u8
            zero_terms_query "all"
          }
        }
      }
      json = definition.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse <<-J
        {
          "query": {
            "match_phrase": {
              "description": {
                "query":            "to be or not to be",
                "zero_terms_query": "all",
                "analyzer":         "my_analyzer",
                "slop":             1
              }
            }
          }
        }
      J
      parsed.should eq expected
    end
  end
end
