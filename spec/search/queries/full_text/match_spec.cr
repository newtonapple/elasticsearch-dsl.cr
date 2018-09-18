require "../../../spec_helper"

describe Queries::Match do
  describe "#to_json" do
    it "generates JSON for simple match query" do
      search {
        query(Queries::Match) {
          match "age", "10"
          _name "age"
        }
      }.should eq_to_json <<-JSON
        {
           "query": {
              "match": {
                "age":"10",
                "_name": "age"
              }
            }
        }
      JSON
    end

    it "generates JSON for complex match query" do
      search {
        query(Queries::Match) {
          match "age" {
            query "10"
            operator "and"
            fuzziness 1_u8
            _name "age"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "match": {
              "age": {
                "operator": "and",
                "fuzziness": 1,
                "query": "10",
                "_name": "age"
              }
            }
          }
        }
      JSON
    end
  end
end
