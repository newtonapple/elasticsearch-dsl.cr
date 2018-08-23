require "../../spec_helper"

describe Queries::MultiMatch do
  describe "#to_json" do
    it "generates 'multi_match' JSON" do
      search {
        query(Queries::MultiMatch) {
          multi_match {
            analyzer "standard"
            fields ["*_name^2", "title"]
            query "david"
            cutoff_frequency 0.01
            type "phrase"
            operator "and"
          }
        }
      }.should eq_json_str <<-J
        {
          "query": {
            "multi_match": {
              "fields": ["*_name^2", "title"],
              "analyzer": "standard",
              "query": "david",
              "type": "phrase",
              "operator": "and",
              "cutoff_frequency": 0.01
            }
          }
        }
      J
    end
  end
end
