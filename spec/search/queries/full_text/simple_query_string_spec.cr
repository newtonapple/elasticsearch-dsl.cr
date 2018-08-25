require "../../../spec_helper"

describe Queries::SimpleQueryString do
  describe "#to_json" do
    it "generates JSON for simple_query_string query" do
      search {
        query(Queries::SimpleQueryString) {
          simple_query_string {
            allow_leading_wildcard true
            analyzer "standard"
            analyze_wildcard true
            auto_generate_phrase_queries true
            auto_generate_synonyms_phrase_query true
            boost 2.25
            cutoff_frequency 0.001
            default_field "name"
            default_operator "and"
            enable_position_increments false
            flags "ALL"
            fields ["name", "title"]
            fuzzy_max_expansions 2_u8
            fuzziness 3_u8
            fuzzy_rewrite "constant_score"
            lenient true
            max_expansions 3_u8
            max_determinized_states 9_000_u64
            minimum_should_match 5
            operator "and"
            phrase_slop 2_u8
            prefix_length 3_u8
            quote_field_suffix ".exact"
            query "basketball \"jones\""
            quote_analyzer "keyword_analyzer"
            tie_breaker 0.3
            type "cross_fields"
          }
        }
      }.should eq_json_str <<-J
        {
          "query": {
            "simple_query_string": {
              "allow_leading_wildcard": true,
              "analyzer": "standard",
              "analyze_wildcard": true,
              "auto_generate_phrase_queries": true,
              "auto_generate_synonyms_phrase_query": true,
              "boost": 2.25,
              "cutoff_frequency": 0.001,
              "default_field": "name",
              "default_operator": "and",
              "enable_position_increments": false,
              "flags": "ALL",
              "fields": ["name", "title"],
              "fuzzy_max_expansions": 2,
              "fuzziness": 3,
              "fuzzy_rewrite": "constant_score",
              "lenient": true,
              "max_expansions": 3,
              "max_determinized_states": 9000,
              "minimum_should_match": 5,
              "operator": "and",
              "phrase_slop": 2,
              "prefix_length": 3,
              "query": "basketball \\\"jones\\\"",
              "quote_field_suffix": ".exact",
              "quote_analyzer": "keyword_analyzer",
              "tie_breaker": 0.3,
              "type": "cross_fields"
            }
          }
        }
      J
    end
  end
end
