require "../../../spec_helper"
include Queries

describe Prefix do
  describe "#to_json" do
    it "generates JSON for simple prefix query" do
      search {
        query(Prefix) { prefix "user", "wil" }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "prefix": { "user": "wil" }
          }
        }
      JSON
    end

    it "generates JSOn for complex prefix query" do
      search {
        query(Prefix) {
          prefix ("title") {
            value "Crystal"
            boost 3.14
            rewrite "constant_score_boolean"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "prefix": {
              "title": {
                "boost": 3.14,
                "rewrite": "constant_score_boolean",
                "value": "Crystal"
              }
            }
          }
        }
      JSON
    end
  end
end
