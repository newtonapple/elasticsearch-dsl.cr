module Elasticsearch::DSL::Search::Queries
  #
  # Terms API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-terms-query.html
  class Terms < Base
    Macro.mapping_with_field_query(terms, Type::ScalarArray, {
      id:    String?,
      index: String?,
      path:  String?,
      type:  String?,
    })
  end
end
