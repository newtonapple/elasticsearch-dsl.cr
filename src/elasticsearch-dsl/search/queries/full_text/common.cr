module Elasticsearch::DSL::Search::Queries
  class Common < Base
    Macro.mapping_with_field(common, {
      analyzer:             String?,
      boost:                Type::Number?,
      cutoff_frequency:     Type::Number?,
      high_freq_operator:   String?,
      low_freq_operator:    String?,
      minimum_should_match: Type::Int | String | MinimumShouldMatch?,
      query:                String?,
    })

    def minimum_should_match
      min_match = MinimumShouldMatch.new
      with min_match yield min_match
      self.minimum_should_match = min_match
    end

    class MinimumShouldMatch
      Macro.mapping({
        # TODO: confirm if low_freq & high_freq accept the same params as regular
        # minimum_should_match: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-minimum-should-match.html
        low_freq:  Type::Int? | String,
        high_freq: Type::Int? | String,
      })
    end
  end
end
