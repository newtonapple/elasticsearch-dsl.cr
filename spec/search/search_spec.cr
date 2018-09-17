require "../spec_helper"
include Queries

describe Search do
  describe "request body parameters" do
    it "accepts standard request body parameters" do
      search {
        query(Match) { match "title", "hello" }
        from 0_u8
        size 200_u32
        batched_reduce_size 512_u32
        terminate_after 2000_u64
        timeout "500ms"
        stats ["group1", "group2"]
        _source ["title", "body"]
      }.should eq_to_json <<-JSON
        {
          "query": { "match": {"title": "hello" } },
          "_source": ["title", "body"],
          "stats": ["group1", "group2"],
          "from": 0,
          "size": 200,
          "batched_reduce_size": 512,
          "terminate_after": 2000,
          "timeout": "500ms"
        }
      JSON
    end
  end

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
