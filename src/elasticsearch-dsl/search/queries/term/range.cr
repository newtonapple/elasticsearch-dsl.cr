module Elasticsearch::DSL::Search::Queries
  #
  # Prefix Query API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-range-query.html

  class RangeQuery < Base
    Macro.mapping_with_field(range, {
      boost:     Type::Number?,
      format:    String?,
      gt:        Type::Scalar?,
      gte:       Type::Scalar?,
      lt:        Type::Scalar?,
      lte:       Type::Scalar?,
      time_zone: String?,
    })
  end
end
