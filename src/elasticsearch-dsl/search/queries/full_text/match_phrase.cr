module Elasticsearch::DSL::Search::Queries
  class MatchPhrase < QueryType
    Macro.mapping_with_field_query(match_phrase, String, {
      analyzer:         String?,
      query:            String?,
      slop:             UInt8?,
      zero_terms_query: String?,
    })
  end
end
