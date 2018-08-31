require "../../../spec_helper"
include Queries

describe Regexp do
  describe "#to_json" do
    it "generates JSON for simple regexp query" do
      search {
        query(Regexp) { regexp "name.first", "wi.*y" }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "regexp": { "name.first": "wi.*y" }
          }
        }
      JSON
    end

    it "generates JSOn for complex regexp query" do
      search {
        query(Regexp) {
          regexp ("title") {
            value "Crystal.*Metaprogramming.*"
            flags "INTERSECTION|COMPLEMENT|EMPTY"
            boost 9.99
            max_determinized_states 10000_u32
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "regexp": {
              "title": {
                "boost": 9.99,
                "flags": "INTERSECTION|COMPLEMENT|EMPTY",
                "value": "Crystal.*Metaprogramming.*",
                "max_determinized_states": 10000
              }
            }
          }
        }
      JSON
    end
  end
end
