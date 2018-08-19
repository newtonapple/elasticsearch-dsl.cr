module Elasticsearch::DSL::Search::Queries
  class Match
    Macro.mapping_with_field_query(match, Type::Scalar, {
      analyzer:             String?,
      boost:                Type::Number?,
      cutoff_frequency:     Type::Float?,
      fuzziness:            UInt8 | String?,
      fuzzy_rewrite:        String?,
      fuzzy_transpositions: Bool?,
      lenient:              Bool?,
      max_expansions:       Type::UInt?,
      minimum_should_match: Type::Int | String?,
      operator:             String?,
      prefix_length:        Type::UInt?,
      query:                Type::Scalar?,
      slop:                 UInt8?,
      type:                 String?,
      zero_terms_query:     String?,
    })
  end
end
