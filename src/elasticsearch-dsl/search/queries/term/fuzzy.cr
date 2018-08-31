module Elasticsearch::DSL::Search::Queries
  #
  # Fuzzy Query API:
  #   https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-fuzzy-query.html
  class Fuzzy < Base
    Macro.mapping_with_field_query(fuzzy, String?, {
      boost:          Type::Number?,
      fuzziness:      UInt8 | String?,
      max_expansions: Type::UInt?,
      prefix_length:  Type::UInt?,
      transpositions: Bool?,
      value:          String?,
    })
  end
end
