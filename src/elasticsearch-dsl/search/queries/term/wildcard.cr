module Elasticsearch::DSL::Search::Queries
  #
  # Terms API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-wildcard-query.html
  class Wildcard < Base
    Macro.mapping_with_field_query(wildcard, String?, {
      boost:   Type::Number?,
      rewrite: String?,
      value:   String?,
    })
  end
end
