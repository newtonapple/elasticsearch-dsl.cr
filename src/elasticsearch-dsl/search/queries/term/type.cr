
module Elasticsearch::DSL::Search::Queries
  #
  # Type Query API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-type-query.html
  class TypeQuery < Base
    Macro.mapping(type, {
      value: String?,
    })
  end
end
