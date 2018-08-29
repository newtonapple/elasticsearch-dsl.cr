require "../../../spec_helper"
include Queries

describe BoolQuery do
  describe "#to_json" do
    it "generates JSON for bool query" do
      search {
        query(BoolQuery) {
          bool {
            must(MatchAll) {
              match_all { }
            }

            should(QueryString) {
              query "Will Sm*"
            }

            mp = MatchPhrase.new
            mp.match_phrase("lyrics") {
              query "on your mark ready set let's go"
            }
            should(mp)
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "bool": {
              "must": {
                "match_all": { }
              },
              "should": [
                {
                  "query_string": {
                    "query": "Will Sm*"
                  }
                },
                {
                  "match_phrase": {
                    "lyrics": {
                      "query": "on your mark ready set let's go"
                    }
                  }
                }
              ]
            }
          }
        }
      JSON
    end
  end
end
