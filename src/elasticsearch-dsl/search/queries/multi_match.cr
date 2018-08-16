module Elasticsearch::DSL::Search::Queries
  class MultiMatch
    Macro.mapping(
      multi_match: {type: Query, default: Query.new},
    )

    def multi_match(&block)
      with @multi_match yield @multi_match
    end

    class Query
      Macro.mapping({
        analyzer:             String?,
        boost:                Type::Number?,
        cutoff_frequency:     Type::Float?,
        fields:               Array(String)?,
        fuzziness:            UInt8 | String?,
        fuzzy_rewrite:        String?,
        max_expansions:       Type::UInt?,
        minimum_should_match: Type::Int | String?,
        operator:             String?,
        prefix_length:        Type::UInt?,
        query:                String?,
        tie_breaker:          Type::Float?,
        type:                 String?,
        lenient:              Bool?,
        zero_terms_query:     String?,
      })
    end
  end
end
