module Elasticsearch::DSL::Search::Queries
  class MatchPhrasePrefix < QueryType
    Macro.mapping_with_field_query(match_phrase_prefix, String, {
      analyzer:         String?,
      query:            String?,
      slop:             UInt8?,
      zero_terms_query: String?,
      max_expansions:   Type::UInt?,
    })
  end
end
