require "../../../spec_helper"
include Queries

describe FunctionScore do
  describe "#to_json" do
    it "generates JSON for weight score function" do
      search {
        query {
          function_score {
            query(MatchAll) {
              match_all { }
            }
            weight 18
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "function_score": {
              "query": {
                "match_all": { }
              },
              "weight": 18
            }
          }
        }
      JSON
    end

    it "generates JSON for field_value_factor score function" do
      search {
        query {
          function_score {
            query(MatchAll) {
              match_all { }
            }
            field_value_factor {
              field "likes"
              factor 1.2
              modifier "ln1p"
              missing 1
            }
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "function_score": {
              "query": { "match_all" : {} },
              "field_value_factor": {
                "factor": 1.2,
                "field": "likes",
                "missing": 1,
                "modifier": "ln1p"
              }
            }
          }
        }
      JSON
    end

    it "generates JSON for random_score function" do
      search {
        query {
          function_score {
            query(Match) {
              match "title", "random"
            }
            random_score {
              field "id"
              seed 999
            }
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "function_score": {
              "query": { "match": { "title": "random" } },
              "random_score": {
                "field": "id",
                "seed": 999
              }
            }
          }
        }
      JSON
    end

    it "generates JSON for script_score function" do
      search {
        query {
          function_score {
            query(MatchAll) {
              match_all { }
            }
            script_score {
              params(Hash(String, Type::Scalar){"a" => 5, "b" => 1.2})
              source "params.a / Math.pow(params.b, doc['likes'].value)"
            }
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "function_score": {
              "query": {
                "match_all": { }
              },
              "script_score": {
                "script": {
                  "params": { "a": 5, "b": 1.2 },
                  "source": "params.a / Math.pow(params.b, doc['likes'].value)"
                }
              }
            }
          }
        }
      JSON
    end

    it "generates JSON for gauss decay score function" do
      search {
        query {
          function_score {
            query(MatchAll) {
              match_all { }
            }
            gauss("dates") {
              origin "2018-09-12"
              scale "10d"
              offset "5d"
              decay 0.5
              multi_value_mode "avg"
            }
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "function_score": {
              "query": {
                "match_all": { }
              },
              "gauss": {
                "dates": {
                  "decay": 0.5,
                  "origin": "2018-09-12",
                  "scale": "10d",
                  "offset": "5d"
                },
                "multi_value_mode": "avg"
              }
            }
          }
        }
      JSON
    end

    it "generates JSON for combined functions array" do
      search {
        query {
          function_score {
            query(Match) {
              match "title", "programming"
            }
            function {
              gauss("price") {
                origin 0
                scale 39.99
              }
            }
            function {
              filter(Match) { match "title", "crystal" }
              weight 2
            }
            function {
              filter(Match) { match "title", "ruby" }
              weight 1.5
            }
            score_mode "multiply"
            boost_mode "multiply"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "function_score": {
              "query": { "match": { "title": "programming" } },
              "boost_mode": "multiply",
              "score_mode": "multiply",
              "functions": [
                {
                  "gauss": { "price": { "origin": 0, "scale": 39.99 } }
                },
                {
                  "filter": { "match": { "title": "crystal"} },
                  "weight": 2
                },
                {
                  "filter": { "match": { "title": "ruby"} },
                  "weight": 1.5
                }
              ]
            }
          }
        }
      JSON
    end
  end
end
