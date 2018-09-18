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
              _name "default_field"
            }

            should(Match) {
              match("title") {
                query "jiggy wit it"
                operator "and"
                _name "title"
              }
            }

            mp = MatchPhrase.new
            mp.match_phrase("lyrics") {
              query "on your mark ready set let's go"
              _name "lyrics"
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
                    "query": "Will Sm*",
                    "_name": "default_field"
                  }
                },
                {
                  "match": {
                    "title": {
                      "query": "jiggy wit it",
                      "operator": "and",
                      "_name": "title"
                    }
                  }
                },
                {
                  "match_phrase": {
                    "lyrics": {
                      "query": "on your mark ready set let's go",
                      "_name": "lyrics"
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
