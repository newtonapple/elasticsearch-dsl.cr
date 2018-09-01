require "../../../spec_helper"
include Queries

describe ConstantScore do
  describe "#to_json" do
    it "generates JSON for constant_score query" do
      search {
        query {
          constant_score {
            filter(Term) {
              term "title", "crystal programming"
            }
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "constant_score": {
              "filter": {
                "term": { "title": "crystal programming" }
              }
            }
          }
        }
      JSON
    end
  end
end
