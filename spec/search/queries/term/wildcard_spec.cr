require "../../../spec_helper"
include Queries

describe Wildcard do
  describe "#to_json" do
    it "generates JSON for simple wildcard query" do
      search {
        query(Wildcard) { wildcard "name", "wil*ith" }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "wildcard": { "name": "wil*ith" }
          }
        }
      JSON
    end

    it "generates JSOn for complex wildcard query" do
      search {
        query(Wildcard) {
          wildcard ("title") {
            value "Crystal *"
            rewrite "constant_score"
            boost 3.14
            _name "wildcard"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "wildcard": {
              "title": {
                "boost": 3.14,
                "rewrite": "constant_score",
                "value": "Crystal *",
                "_name": "wildcard"
              }
            }
          }
        }
      JSON
    end
  end
end
