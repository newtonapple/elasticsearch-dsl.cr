module Elasticsearch::DSL::Search::Queries
  #
  # Ids Query API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-ids-query.html
  class Ids < Base
    Macro.mapping(ids, {
      type:   String?,
      values: Array(String)?,
    })
  end
end
