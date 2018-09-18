module Elasticsearch::DSL::Search::Queries
  #
  # Exists Query API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-exists-query.html
  class Exists < Base
    Macro.mapping(exists, {
      field: String?,
      _name: String?,
    })
  end
end
