require "../../../spec_helper"

describe Queries::MatchAll do
  describe "#to_json" do
    it "generates JSON for match_all query with empty body" do
      search {
        query(Queries::MatchAll) { match_all }
      }.should eq_to_json %({"query": {"match_all": {}}})
    end

    it "generates JSON for match_all with boost" do
      search {
        query(Queries::MatchAll) {
          match_all { boost 100.01 }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "match_all": { "boost": 100.01 }
          }
        }
      JSON
    end
  end
end
