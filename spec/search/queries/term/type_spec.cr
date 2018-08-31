require "../../../spec_helper"
include Queries

describe TypeQuery do
  describe "#to_json" do
    it "generates JSON for type query" do
      search {
        query {
          type {
            value "_doc"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "type": {
              "value": "_doc"
            }
          }
        }
      JSON
    end
  end
end
