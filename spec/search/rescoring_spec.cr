require "../spec_helper"
include Queries

describe Search do
  describe "#rescore" do
    it "rescores by single rescore_query" do
      search {
        query(Match) { match("name") { query "john smith" } }
        rescore {
          window_size 40_u64
          query {
            rescore_query(Match) { match("title") { query "ceo" } }
            query_weight 0.5
            rescore_query_weight 1.5
            score_mode "multiply"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": { "match": { "name": { "query": "john smith" } } },
          "rescore": {
            "query": {
              "score_mode": "multiply",
              "rescore_query": { "match": { "title": { "query": "ceo" } } },
              "query_weight": 0.5,
              "rescore_query_weight": 1.5
            },
            "window_size": 40
          }
        }
      JSON
    end

    it "rescores by multiple rescore_queries" do
      search {
        query(Match) {
          match("message") {
            query "the quick brown"
            operator "or"
          }
        }

        rescore {
          window_size 100_u64
          query {
            rescore_query(MatchPhrase) {
              match_phrase("message") {
                query "the quick brown"
                slop 2_u8
              }
            }
            query_weight 0.7
            rescore_query_weight 1.2
          }
        }

        rescore {
          window_size 10_u8
          query {
            score_mode "multiply"
            rescore_query {
              function_score {
                script_score {
                  source "Math.log10(doc.likes.value + 2)"
                }
              }
            }
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query" : {
            "match" : {
                "message" : {
                  "operator" : "or",
                  "query" : "the quick brown"
                }
            }
          },
          "rescore" : [ {
            "window_size" : 100,
            "query" : {
                "rescore_query" : {
                  "match_phrase" : {
                      "message" : {
                        "query" : "the quick brown",
                        "slop" : 2
                      }
                  }
                },
                "query_weight" : 0.7,
                "rescore_query_weight" : 1.2
            }
          }, {
            "window_size" : 10,
            "query" : {
                "score_mode": "multiply",
                "rescore_query" : {
                  "function_score" : {
                      "script_score": {
                        "script": {
                          "source": "Math.log10(doc.likes.value + 2)"
                        }
                      }
                  }
                }
            }
          } ]
        }
      JSON
    end
  end
end
