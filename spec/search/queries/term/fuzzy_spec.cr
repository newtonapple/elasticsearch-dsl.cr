require "../../../spec_helper"
include Queries

describe Fuzzy do
  describe "#to_json" do
    it "generates JSON for simple fuzzy query" do
      search {
        query(Fuzzy) { fuzzy "user", "wil" }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "fuzzy": { "user": "wil" }
          }
        }
      JSON
    end

    it "generates JSOn for complex fuzzy query" do
      search {
        query(Fuzzy) {
          fuzzy ("title") {
            value "cyrstal"
            boost 1.4
            fuzziness "AUTO:3..5"
            prefix_length 0_u8
            max_expansions 101_u32
            transpositions true
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "fuzzy": {
              "title": {
                "boost": 1.4,
                "fuzziness": "AUTO:3..5",
                "prefix_length": 0,
                "max_expansions": 101,
                "transpositions": true,
                "value": "cyrstal"
              }
            }
          }
        }
      JSON
    end
  end
end
