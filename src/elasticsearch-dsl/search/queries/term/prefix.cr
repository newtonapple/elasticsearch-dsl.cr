module Elasticsearch::DSL::Search::Queries
  #
  # Prefix Query API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-prefix-query.html
  class Prefix < Base
    Macro.mapping_with_field_query(prefix, String?, {
      boost:   Type::Number?,
      rewrite: String?,
      value:   String?,
      _name:   String?,
    })
  end
end
