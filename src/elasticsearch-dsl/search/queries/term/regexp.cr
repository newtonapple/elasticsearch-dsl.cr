module Elasticsearch::DSL::Search::Queries
  #
  # Terms API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-regexp-query.html
  class Regexp < Base
    Macro.mapping_with_field_query(regexp, String?, {
      boost:                   Type::Number?,
      flags:                   String?,
      max_determinized_states: Type::UInt?,
      value:                   String?,
    })
  end
end
