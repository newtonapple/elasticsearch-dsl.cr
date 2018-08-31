require "../../../spec_helper"
include Queries

describe Exists do
  describe "#to_json" do
    it "generates JSON for exists query" do
      search {
        query(Exists) {
          exists { field "user" }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "exists": {
              "field": "user"
            }
          }
        }
      JSON
    end
  end
end
