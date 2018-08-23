require "../../../spec_helper"

describe Queries::MatchPhrasePrefix do
  describe "#to_json" do
    it "generates JSON for match_phrase_prefix with a string query" do
      search {
        query(Queries::MatchPhrasePrefix) {
          match_phrase_prefix "body", "that is the question"
        }
      }.should eq_json_str %({"query": {"match_phrase_prefix": {"body": "that is the question"}}})
    end

    it "generates JSON for match_phrase_prefix with complex query" do
      search {
        query(Queries::MatchPhrasePrefix) {
          match_phrase_prefix "description" {
            query "to be or not to be"
            analyzer "my_analyzer"
            slop 1_u8
            max_expansions 10_u32
            zero_terms_query "all"
          }
        }
      }.should eq_json_str <<-J
       {
         "query": {
           "match_phrase_prefix": {
             "description": {
               "query":            "to be or not to be",
               "zero_terms_query": "all",
               "analyzer":         "my_analyzer",
               "slop":             1,
               "max_expansions":   10
             }
           }
         }
       }
     J
    end
  end
end
