module Elasticsearch::DSL::Search::Queries
  class QueryString < Base
    Macro.mapping(query_string, {
      allow_leading_wildcard:              Bool?,
      analyzer:                            String?,
      analyze_wildcard:                    Bool?,
      auto_generate_phrase_queries:        Bool?,
      auto_generate_synonyms_phrase_query: Bool?,
      boost:                               Type::Number?,
      cutoff_frequency:                    Type::Number?,
      default_field:                       String?,
      default_operator:                    String?,
      enable_position_increments:          Bool?,
      fields:                              Array(String)?,
      fuzzy_max_expansions:                Type::UInt?,
      fuzziness:                           UInt8 | String?,
      fuzzy_rewrite:                       String?,
      lenient:                             Bool?,
      max_expansions:                      Type::UInt?,
      max_determinized_states:             Type::UInt?,
      minimum_should_match:                Type::Int | String?,
      operator:                            String?,
      phrase_slop:                         Type::UInt?,
      prefix_length:                       Type::UInt?,
      quote_field_suffix:                  String?,
      query:                               String?,
      quote_analyzer:                      String?,
      tie_breaker:                         Type::Float?,
      type:                                String?,
    })
  end
end
