require "../../../spec_helper"

describe Queries::Match do
  describe "#to_json" do
    it "generates JSON for simple match query" do
      search {
        query(Queries::Match) { match "age", "10" }
      }.should eq_json_str %({"query": {"match": {"age":"10"}}})
    end

    it "generates JSON for complex match query" do
      search {
        query(Queries::Match) {
          match "age" {
            query "10"
            operator "and"
            fuzziness 1_u8
          }
        }
      }.should eq_json_str <<-J
        {
          "query": {
              "match": {
              "age": {
                "operator": "and",
                "fuzziness": 1,
                "query": "10"
              }
            }
          }
        }
      J
    end
  end
end