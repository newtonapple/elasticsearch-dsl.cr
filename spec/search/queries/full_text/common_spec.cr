require "../../../spec_helper"

describe Queries::Common do
  describe "#to_json" do
    it "generate JSON for simple common query" do
      search {
        query(Queries::Common) {
          common "my_body" {
            query "Last week, messed around and got a triple double..."
            analyzer "my_analyzer"
            cutoff_frequency 3000
            low_freq_operator "and"
            minimum_should_match "3<-15% 9<-5"
          }
        }
      }.should eq_json_str <<-J
        {
          "query": {
            "common": {
              "my_body": {
                "analyzer": "my_analyzer",
                "cutoff_frequency": 3000,
                "low_freq_operator": "and",
                "minimum_should_match": "3<-15% 9<-5",
                "query": "Last week, messed around and got a triple double..."
              }
            }
          }
        }
      J
    end
  end

  it "generates JSON for complex common query" do
    search {
      query(Queries::Common) {
        common "content" {
          analyzer "standard"
          query "the quick brown fix jumped over the lazy dog"
          cutoff_frequency 0.0001
          low_freq_operator "and"
          high_freq_operator "or"
          minimum_should_match {
            low_freq 4
            high_freq 3
          }
        }
      }
    }.should eq_json_str <<-J
      {
        "query": {
          "common": {
            "content": {
              "analyzer": "standard",
              "query": "the quick brown fix jumped over the lazy dog",
              "cutoff_frequency": 0.0001,
              "low_freq_operator": "and",
              "high_freq_operator": "or",
              "minimum_should_match": {
                "low_freq": 4,
                "high_freq": 3
              }
            }
          }
        }
      }
    J
  end
end
