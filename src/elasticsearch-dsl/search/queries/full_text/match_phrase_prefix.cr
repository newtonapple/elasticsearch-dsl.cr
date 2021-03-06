module Elasticsearch::DSL::Search::Queries
  class MatchPhrasePrefix < Base
    Macro.mapping_with_field_query(match_phrase_prefix, String, {
      analyzer:         String?,
      query:            String?,
      slop:             UInt8?,
      zero_terms_query: String?,
      max_expansions:   Type::UInt?,
      _name:            String?,
    })
  end
end
