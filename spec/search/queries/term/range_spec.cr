require "../../../spec_helper"
include Queries

describe RangeQuery do
  describe "#to_json" do
    it "generates JSON for number range query" do
      search {
        query(RangeQuery) {
          range("id") {
            gt 120
            lte 999
            boost 2.0
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "range": {
              "id": {
                "boost": 2.0,
                "gt": 120,
                "lte": 999
              }
            }
          }
        }
      JSON
    end

    it "generates JSON for date range query" do
      search {
        query(RangeQuery) {
          range("date") {
            gte "01/01/2018"
            lt "2019"
            format "dd/MM/yyyy||yyyy"
            time_zone "+08:00"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "range": {
              "date": {
                "gte": "01/01/2018",
                "lt": "2019",
                "format": "dd/MM/yyyy||yyyy",
                "time_zone": "+08:00"
              }
            }
          }
        }
      JSON
    end
  end
end
