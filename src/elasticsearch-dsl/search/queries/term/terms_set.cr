module Elasticsearch::DSL::Search::Queries
  #
  # Terms Set Query API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-terms-set-query.html
  class TermsSet < Base
    Macro.mapping_with_field(terms_set, {
      terms:                       Type::ScalarArray?, # TODO: confirm terms can be a number
      minimum_should_match_field:  String?,
      minimum_should_match_script: String?,
    })
  end
end
