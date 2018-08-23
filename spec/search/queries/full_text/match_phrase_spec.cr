require "../../../spec_helper"

describe Queries::MatchPhrase do
  describe "#to_json" do
    it "generates JSON for match_phrase with a string query" do
      search {
        query(Queries::MatchPhrase) {
          match_phrase "body", "that is the question"
        }
      }.should eq_json_str %({"query": {"match_phrase": {"body": "that is the question"}}})
    end

    it "generates JSON for match_phrase with complex query" do
      search {
        query(Queries::MatchPhrase) {
          match_phrase "description" {
            query "to be or not to be"
            analyzer "my_analyzer"
            slop 1_u8
            zero_terms_query "all"
          }
        }
      }.should eq_json_str <<-J
       {
         "query": {
           "match_phrase": {
             "description": {
               "query":            "to be or not to be",
               "zero_terms_query": "all",
               "analyzer":         "my_analyzer",
               "slop":             1
             }
           }
         }
       }
     J
    end
  end
end
