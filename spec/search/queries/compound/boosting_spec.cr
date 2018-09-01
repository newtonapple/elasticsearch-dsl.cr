
require "../../../spec_helper"
include Queries

describe Boosting do
  describe "#to_json" do
    it "generates JSON for boosting query" do
      search {
        query {
          boosting {
            positive(Match) {
              match "body", "crystal programming"
            }
            negative(Match) {
              match "body", "ruby"
            }
            negative_boost 0.2
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "boosting": {
              "positive": {
                "match": { "body": "crystal programming" }
              },
              "negative": {
                "match": { "body": "ruby" }
              },
              "negative_boost": 0.2
            }
          }
        }
      JSON
    end
  end
end
