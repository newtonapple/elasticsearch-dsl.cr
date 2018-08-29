require "../../../spec_helper"
include Queries

describe Term do
  describe "#to_json" do
    it "generates JSON for simple term query" do
      search {
        query(Term) { term "doc_id", 1337 }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "term": {
              "doc_id": 1337
            }
          }
        }
      JSON
    end

    it "generates JSOn for complex term query" do
      search {
        query(Term) {
          term ("title.exact") {
            value "Crystal Programming"
            boost 2.0
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "term": {
              "title.exact": {
                "boost": 2.0,
                "value": "Crystal Programming"
              }
            }
          }
        }
      JSON
    end
  end
end
