require "../../../spec_helper"

include Queries
describe BoolQuery do
  describe "#to_json" do
    it "generates JSON for bool query" do
    search {
        query(BoolQuery) {
          must(MatchAll) {
            match_all { }
          }

          should(QueryString) {
            query_string {
              query "Will Sm*"
            }
          }

          mp = MatchPhrase.new
          mp.match_phrase("lyrics") {
              query "on your mark ready set let's go"
          }
          should(mp)
        }
      }.should eq_json_str <<-J
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
      J
    end
  end
end
