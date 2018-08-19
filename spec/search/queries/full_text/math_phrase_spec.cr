require "../../../spec_helper"

describe Queries::MatchPhrase do
  describe "#from_json" do
    it "parses math_phrase with string query" do
      match_phrase = Queries::MatchPhrase.from_json(%({"match_phrase": {"title": "this is a good book"}}))
      match_phrase.field.should eq "title"
      match_phrase.query.should eq "this is a good book"

      full_query = Search(Queries::MatchPhrase).from_json(%({"query": {"match_phrase": {"title": "this is a good book"}}}))
      match_phrase = full_query.query.as(Queries::MatchPhrase)
      match_phrase.field.should eq "title"
      match_phrase.query.should eq "this is a good book"
    end

    it "parses match_phrase with complex query" do
      full_query = Search(Queries::MatchPhrase).from_json <<-J
        {
          "query": {
            "match_phrase": {
              "body": {
                "query":            "to be or not to be",
                "zero_terms_query": "all",
                "analyzer":         "my_analyzer",
                "slop":             1
              }
            }
          }
        }
      J
      match_phrase = full_query.query.as(Queries::MatchPhrase)
      match_phrase.field.should eq "body"
      query = match_phrase.query.as(Queries::MatchPhrase::Query)
      query.query.should eq "to be or not to be"
      query.zero_terms_query.should eq "all"
      query.analyzer.should eq "my_analyzer"
      query.slop.should eq 1
    end
  end

  describe "#to_json" do
    it "generates JSON for match_phrase with a string query" do
      definition = search(Queries::MatchPhrase) {
        query {
          match_phrase "body", "that is the question"
        }
      }
      json = definition.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse(%({"query": {"match_phrase": {"body": "that is the question"}}}))
      parsed.should eq expected
    end

    it "generates JSON for match_phrase with complex query" do
      definition = search(Queries::MatchPhrase) {
        query {
          match_phrase "description" {
            query "to be or not to be"
            analyzer "my_analyzer"
            slop 1_u8
            zero_terms_query "all"
          }
        }
      }
      json = definition.to_json
      parsed = JSON.parse(json)
      expected = JSON.parse <<-J
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
      parsed.should eq expected
    end
  end
end
