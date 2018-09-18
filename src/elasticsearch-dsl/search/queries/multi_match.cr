module Elasticsearch::DSL::Search::Queries
  class MultiMatch < Base
    Macro.mapping(multi_match, {
      analyzer:             String?,
      boost:                Type::Number?,
      cutoff_frequency:     Type::Number?,
      fields:               Array(String)?,
      fuzziness:            UInt8 | String?,
      fuzzy_rewrite:        String?,
      lenient:              Bool?,
      max_expansions:       Type::UInt?,
      minimum_should_match: Type::Int | String?,
      operator:             String?,
      prefix_length:        Type::UInt?,
      query:                String?,
      tie_breaker:          Type::Float?,
      type:                 String?,
      zero_terms_query:     String?,
      _name:                String?,
    })
  end
end
