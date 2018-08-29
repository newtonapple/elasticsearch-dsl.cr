require "../../../spec_helper"
include Queries

describe Ids do
  describe "#to_json" do
    it "generates JSON for ids query" do
      search {
        query(Ids) {
          ids {
            type "items"
            values ["123", "456", "789"]
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "ids": {
              "type": "items",
              "values": ["123", "456", "789"]
            }
          }
        }
      JSON
    end
  end
end
