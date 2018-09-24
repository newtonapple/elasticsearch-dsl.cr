require "../spec_helper"
include Queries

describe Search do
  describe "#sort" do
    it "sorts by field" do
      search {
        query(Match) { match("title") { query "crystal programming" } }
        sort("price")
      }.should eq_to_json <<-JSON
      {
        "query": { "match": { "title": { "query": "crystal programming" } } },
        "sort": "price"
      }
    JSON
    end

    it "sorts simple field by order" do
      search {
        sort("name", "asc")
        match_all { }
      }.should eq_to_json <<-JSON
        {
          "query": { "match_all": {} },
          "sort": { "name": "asc" }
        }
      JSON
    end

    it "sorts with complex sort" do
      search {
        match_all { }
        sort("counts") {
          order "desc"
          mode "sum"
          missing 0
        }
      }.should eq_to_json <<-JSON
        {
          "query": { "match_all": {} },
          "sort": {
            "counts": {
              "mode": "sum",
              "order": "desc",
              "missing": 0
            }
          }
        }
      JSON
    end

    it "sorts with array of sorting types" do
      search {
        match_all { }
        sort("rating", "desc")
        sort("price")
        sort("sold") { order "desc" }
      }.should eq_to_json <<-JSON
        {
          "query": { "match_all": {} },
          "sort": [
            { "rating": "desc" },
            "price",
            { "sold": { "order": "desc" } }
          ]
        }
      JSON
    end
  end
end
