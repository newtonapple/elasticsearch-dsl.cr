module Elasticsearch::DSL::Search::Queries
  #
  # Term Query API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-terms-query.html
  class Term < Base
    Macro.mapping_with_field_query(term, Type::Scalar, {
      boost: Type::Number?,
      value: Type::Scalar?,
      _name: String?,
    })
  end
end
