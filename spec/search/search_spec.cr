require "../spec_helper"
include Queries

describe Search do
  describe "non-generic query methods" do
    it "allows query method calls without generics" do
      search {
        query {
          query_string {
            query "hello world"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "query_string": {
              "query": "hello world"
            }
          }
        }
      JSON
    end

    it "shortens BoolQuery to bool" do
      search {
        bool {
          must(MultiMatch) {
            fields ["title^2", "description", "body"]
            query "metaprogramming"
          }
          should(MatchPhrase) {
            match_phrase("body") {
              query "crystal magic"
            }
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "bool": {
              "must": {
                "multi_match":{
                  "fields": ["title^2", "description", "body"],
                  "query": "metaprogramming"
                }
              },
              "should": {
                "match_phrase": {
                  "body": {
                    "query": "crystal magic"
                  }
                }
              }
            }
          }
        }
      JSON
    end
  end
end
