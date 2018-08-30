require "../../../spec_helper"
include Queries

describe Terms do
  describe "#to_json" do
    it "generates JSON for simple terms query" do
      search {
        query(Terms) { terms "doc_id", [1337, 1234, 5678] }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "terms": {
              "doc_id": [1337, 1234, 5678]
            }
          }
        }
      JSON
    end

    it "generates JSON for terms lookup query" do
      search {
        query(Terms) {
          terms ("users") {
            index "users"
            type "_doc"
            id "2"
            path "followers"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "terms": {
              "users": {
                "index": "users",
                "id": "2",
                "type": "_doc",
                "path": "followers"
              }
            }
          }
        }
      JSON
    end
  end
end
