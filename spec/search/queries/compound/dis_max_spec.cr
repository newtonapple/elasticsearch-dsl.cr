require "../../../spec_helper"
include Queries

describe DisMax do
  describe "#to_json" do
    it "generates JSON for dis_max query" do
      search {
        query {
          dis_max {
            query(Match) { match "title", "ruby programming" }
            query(Match) { match "body", "ruby programming" }
            boost 1.2
            tie_breaker 0.3
          }
        }
      }.should eq_to_json <<-JSON
       {
         "query": {
           "dis_max": {
             "boost": 1.2,
             "tie_breaker": 0.3,
             "queries": [
               { "match": { "title": "ruby programming" } },
               { "match": { "body": "ruby programming" } }
             ]
           }
         }
       }
     JSON
    end
  end
end
