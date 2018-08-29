require "../../spec_helper"

describe Queries::MultiMatch do
  describe "#to_json" do
    it "generates JSON for multi_match query" do
      search {
        query(Queries::MultiMatch) {
          multi_match {
            analyzer "standard"
            boost 2.5
            cutoff_frequency 0.001
            fields ["*_name^2", "title", "first_name", "last_name"]
            fuzziness "AUTO:3,6"
            lenient false
            minimum_should_match 2
            operator "and"
            prefix_length 3_u64
            query "david johnson james"
            tie_breaker 0.3
            type "best_fields"
            zero_terms_query "all"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "multi_match": {
              "analyzer": "standard",
              "boost": 2.5,
              "fields": ["*_name^2", "title", "first_name", "last_name"],
              "query": "david johnson james",
              "type": "best_fields",
              "operator": "and",
              "minimum_should_match": 2,
              "cutoff_frequency": 0.001,
              "fuzziness": "AUTO:3,6",
              "zero_terms_query": "all",
              "prefix_length": 3,
              "tie_breaker": 0.3,
              "lenient": false
            }
          }
        }
      JSON
    end
  end
end
