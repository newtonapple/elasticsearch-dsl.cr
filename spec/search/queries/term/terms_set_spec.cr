require "../../../spec_helper"
include Queries

describe TermsSet do
  describe "#to_json" do
    it "generates JSON for terms set query with minimum_should_match_field" do
      search {
        query(TermsSet) {
          terms_set("tags") {
            terms ["scala", "crystal", "ruby"]
            minimum_should_match_field "required_matches"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "terms_set": {
              "tags": {
                "terms": ["scala", "crystal", "ruby"],
                "minimum_should_match_field": "required_matches"
              }
            }
          }
        }
      JSON
    end

    it "generates JSON for terms set query with minimum_should_match_script" do
      search {
        query(TermsSet) {
          terms_set("codes") {
            terms [123, 456]
            minimum_should_match_script "Math.min(params.num_terms, doc['required_matches'].value)"
          }
        }
      }.should eq_to_json <<-JSON
        {
          "query": {
            "terms_set": {
              "codes": {
                "terms": [123, 456],
                "minimum_should_match_script": "Math.min(params.num_terms, doc['required_matches'].value)"
              }
            }
          }
        }
      JSON
    end
  end
end
